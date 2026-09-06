/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/circle/detail/bloc/event.dart';
import 'package:beaver/features/circle/detail/bloc/state.dart';
import 'package:beaver/features/circle/detail/data/repositories/repository.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('circle-detail');

class CircleDetailBloc extends Bloc<CircleDetailEvent, CircleDetailState> {
  final CircleDetailRepository _repository;
  static const int _commentLimit = 20;
  static const int _childLimit = 20;

  CircleDetailBloc({CircleDetailRepository? repository})
      : _repository = repository ?? CircleDetailRepository(),
        super(const CircleDetailState()) {
    on<LoadCircleDetailEvent>(_onLoad);
    on<RefreshCircleDetailEvent>(_onRefresh);
    on<LoadMoreCircleCommentsEvent>(_onLoadMore);
    on<LoadChildCircleCommentsEvent>(_onLoadChildren);
    on<AddCircleCommentEvent>(_onAddComment);
    on<ToggleCircleDetailLikeEvent>(_onToggleLike);
    on<SetCircleReplyTargetEvent>(_onSetReplyTarget);
  }

  Future<void> _onLoad(
    LoadCircleDetailEvent event,
    Emitter<CircleDetailState> emit,
  ) async {
    emit(state.copyWith(status: CircleDetailStatus.loading, commentPage: 1));
    _logger.info({'text': '加载圈子动态详情', 'data': {'postId': event.postId}});

    final detailRes = await _repository.loadDetail(event.postId);
    if (detailRes.code != 0 || detailRes.result == null) {
      _logger.warn({
        'text': '圈子动态详情加载失败',
        'data': {'postId': event.postId, 'code': detailRes.code, 'msg': detailRes.msg},
      });
      emit(state.copyWith(
        status: CircleDetailStatus.error,
        errorMessage: detailRes.msg.isNotEmpty ? detailRes.msg : '加载失败',
      ));
      return;
    }
    _logger.info({
      'text': '圈子动态详情加载完成',
      'data': {'postId': event.postId, 'commentCount': detailRes.result!.commentCount},
    });

    final commentRes = await _repository.loadRootComments(
      postId: event.postId,
      page: 1,
      limit: _commentLimit,
    );

    final comments = commentRes.code == 0
        ? (commentRes.result?.list ?? [])
        : detailRes.result!.comments;

    final post = detailRes.result!.copyWith(comments: comments);

    emit(state.copyWith(
      status: CircleDetailStatus.success,
      post: post,
      commentPage: 1,
      hasMoreComments: comments.length < post.commentCount,
      childPageMap: const {},
      clearReplyTarget: true,
    ));
  }

  Future<void> _onRefresh(
    RefreshCircleDetailEvent event,
    Emitter<CircleDetailState> emit,
  ) async {
    final postId = state.post?.postId;
    if (postId == null) return;
    add(LoadCircleDetailEvent(postId));
  }

  Future<void> _onLoadMore(
    LoadMoreCircleCommentsEvent event,
    Emitter<CircleDetailState> emit,
  ) async {
    final post = state.post;
    if (post == null || !state.hasMoreComments || state.isLoadingComments) {
      return;
    }

    emit(state.copyWith(isLoadingComments: true));
    final nextPage = state.commentPage + 1;
    final res = await _repository.loadRootComments(
      postId: post.postId,
      page: nextPage,
      limit: _commentLimit,
    );

    if (res.code != 0 || (res.result?.list.isEmpty ?? true)) {
      emit(state.copyWith(isLoadingComments: false, hasMoreComments: false));
      return;
    }

    final more = res.result!.list;
    final merged = [...post.comments, ...more];
    emit(state.copyWith(
      post: post.copyWith(comments: merged),
      commentPage: nextPage,
      hasMoreComments: merged.length < post.commentCount,
      isLoadingComments: false,
    ));
  }

  Future<void> _onLoadChildren(
    LoadChildCircleCommentsEvent event,
    Emitter<CircleDetailState> emit,
  ) async {
    final post = state.post;
    if (post == null) return;

    final root = event.rootComment;
    final currentPage = state.childPageMap[root.commentId] ?? 0;
    final nextPage = currentPage + 1;

    final res = await _repository.loadChildComments(
      postId: post.postId,
      parentId: root.commentId,
      page: nextPage,
      limit: _childLimit,
    );
    if (res.code != 0) return;

    final comments = List<ICircleCommentItem>.from(post.comments);
    final rootIndex =
        comments.indexWhere((c) => c.commentId == root.commentId);
    if (rootIndex < 0) return;

    final existing = comments[rootIndex];
    final existingChildren = existing.children;
    final more = res.result?.list ?? <ICircleCommentItem>[];
    final List<ICircleCommentItem> mergedChildren =
        nextPage == 1 ? more : [...existingChildren, ...more];

    comments[rootIndex] = existing.copyWith(
      childCount: res.result?.count ?? existing.childCount,
      children: mergedChildren,
    );

    final childPageMap = Map<String, int>.from(state.childPageMap);
    childPageMap[root.commentId] = nextPage;

    emit(state.copyWith(
      post: post.copyWith(comments: comments),
      childPageMap: childPageMap,
    ));
  }

  Future<void> _onAddComment(
    AddCircleCommentEvent event,
    Emitter<CircleDetailState> emit,
  ) async {
    final post = state.post;
    if (post == null || event.content.trim().isEmpty) return;

    String? parentId;
    String? replyToCommentId;
    final target = event.targetComment;
    if (target != null) {
      replyToCommentId = target.commentId;
      parentId =
          target.parentId.isNotEmpty ? target.parentId : target.commentId;
    }
    _logger.info({
      'text': '发表评论',
      'data': {
        'postId': post.postId,
        'parentId': parentId,
        'replyToCommentId': replyToCommentId,
        'contentLength': event.content.trim().length,
      },
    });

    final res = await _repository.addComment(
      postId: post.postId,
      content: event.content.trim(),
      parentId: parentId,
      replyToCommentId: replyToCommentId,
    );

    if (res.code != 0 || res.result == null) {
      _logger.warn({
        'text': '评论发表失败',
        'data': {'postId': post.postId, 'code': res.code, 'msg': res.msg},
      });
      emit(state.copyWith(
        errorMessage: res.msg.isNotEmpty ? res.msg : '评论发送失败',
      ));
      return;
    }
    _logger.info({
      'text': '评论发表成功',
      'data': {'postId': post.postId, 'commentId': res.result!.commentId},
    });

    final created = res.result!;
    final newComment = ICircleCommentItem(
      commentId: created.commentId,
      userId: created.userId,
      userName: created.userName,
      avatar: created.avatar,
      content: created.content,
      parentId: created.parentId,
      replyToCommentId: created.replyToCommentId,
      replyToUserName: created.replyToUserName,
      createdAt: created.createdAt,
    );

    var comments = List<ICircleCommentItem>.from(post.comments);
    if (parentId == null || parentId.isEmpty) {
      comments.insert(0, newComment);
    } else {
      final rootIndex = comments.indexWhere((c) => c.commentId == parentId);
      if (rootIndex >= 0) {
        final root = comments[rootIndex];
        final children = List<ICircleCommentItem>.from(root.children);
        final insertAfter =
            children.indexWhere((c) => c.commentId == replyToCommentId);
        if (insertAfter >= 0) {
          children.insert(insertAfter + 1, newComment);
        } else {
          children.add(newComment);
        }
        comments[rootIndex] = root.copyWith(
          childCount: root.childCount + 1,
          children: children,
        );
      } else {
        comments.insert(0, newComment);
      }
    }

    emit(state.copyWith(
      post: post.copyWith(
        comments: comments,
        commentCount: post.commentCount + 1,
      ),
      clearReplyTarget: true,
    ));
  }

  Future<void> _onToggleLike(
    ToggleCircleDetailLikeEvent event,
    Emitter<CircleDetailState> emit,
  ) async {
    final post = state.post;
    if (post == null) return;

    final nextStatus = !post.isLiked;
    _logger.info({
      'text': '切换圈子动态点赞',
      'data': {'postId': post.postId, 'nextStatus': nextStatus},
    });
    final res = await _repository.toggleLike(
      postId: post.postId,
      status: nextStatus,
    );
    if (res.code != 0) {
      _logger.warn({
        'text': '点赞操作失败',
        'data': {'postId': post.postId, 'code': res.code, 'msg': res.msg},
      });
      emit(state.copyWith(
        errorMessage: res.msg.isNotEmpty ? res.msg : '操作失败',
      ));
      return;
    }
    _logger.info({
      'text': '点赞状态已更新',
      'data': {'postId': post.postId, 'isLiked': nextStatus},
    });

    emit(state.copyWith(
      post: post.copyWith(
        isLiked: nextStatus,
        likeCount: (post.likeCount + (nextStatus ? 1 : -1)).clamp(0, 1 << 30),
      ),
    ));
  }

  void _onSetReplyTarget(
    SetCircleReplyTargetEvent event,
    Emitter<CircleDetailState> emit,
  ) {
    if (event.target == null) {
      emit(state.copyWith(clearReplyTarget: true));
      return;
    }
    emit(state.copyWith(replyTarget: event.target));
  }
}
