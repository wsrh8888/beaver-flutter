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
import 'package:beaver/features/circle/feed/bloc/event.dart';
import 'package:beaver/features/circle/feed/bloc/state.dart';
import 'package:beaver/features/circle/feed/data/repositories/repository.dart';

class CircleFeedBloc extends Bloc<CircleFeedEvent, CircleFeedState> {
  final CircleFeedRepository _repository;
  final String circleId;
  final int limit = 20;

  CircleFeedBloc({
    required this.circleId,
    CircleFeedRepository? repository,
  })  : _repository = repository ?? CircleFeedRepository(),
        super(const CircleFeedState()) {
    on<LoadCircleFeedEvent>(_onLoad);
    on<ToggleLikeCirclePostEvent>(_onToggleLike);
  }

  Future<void> _onLoad(
    LoadCircleFeedEvent event,
    Emitter<CircleFeedState> emit,
  ) async {
    if (state.status == CircleFeedStatus.loading) return;

    final isRefresh = event.refresh;
    final nextPage = isRefresh ? 1 : state.page + 1;

    if (isRefresh || state.posts.isEmpty) {
      emit(state.copyWith(status: CircleFeedStatus.loading));
    }

    final res = await _repository.getPostList(
      circleId: circleId,
      page: nextPage,
      limit: limit,
    );

    if (res.code != 0) {
      emit(state.copyWith(
        status: CircleFeedStatus.error,
        errorMessage: res.msg.isNotEmpty ? res.msg : '获取帖子失败',
      ));
      return;
    }

    final newPosts = res.result?.list ?? [];
    final updatedPosts =
        isRefresh ? newPosts : [...state.posts, ...newPosts];

    emit(state.copyWith(
      status: CircleFeedStatus.success,
      posts: updatedPosts,
      page: nextPage,
      hasMore: newPosts.length >= limit,
    ));
  }

  Future<void> _onToggleLike(
    ToggleLikeCirclePostEvent event,
    Emitter<CircleFeedState> emit,
  ) async {
    final index = state.posts.indexWhere((p) => p.postId == event.postId);
    if (index == -1) return;

    final post = state.posts[index];
    final nextStatus = !post.isLiked;
    final optimistic = post.copyWith(
      isLiked: nextStatus,
      likeCount: (post.likeCount + (nextStatus ? 1 : -1)).clamp(0, 1 << 30),
    );

    final updated = List.of(state.posts);
    updated[index] = optimistic;
    emit(state.copyWith(posts: updated));

    final res = await _repository.toggleLike(
      postId: event.postId,
      status: nextStatus,
    );

    if (res.code != 0) {
      updated[index] = post;
      emit(state.copyWith(
        posts: List.of(updated),
        errorMessage: res.msg.isNotEmpty ? res.msg : '操作失败',
      ));
    }
  }
}
