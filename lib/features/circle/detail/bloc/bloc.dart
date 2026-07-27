import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/circle/detail/bloc/event.dart';
import 'package:beaver/features/circle/detail/bloc/state.dart';
import 'package:beaver/features/circle/detail/data/repositories/repository.dart';
import 'package:beaver/types/api/circle.dart';

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

    final detailRes = await _repository.loadDetail(event.postId);
    if (detailRes.code != 0 || detailRes.result == null) {
      emit(state.copyWith(
        status: CircleDetailStatus.error,
        errorMessage: detailRes.msg.isNotEmpty ? detailRes.msg : '加载失败',
      ));
      return;
    }

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
    final mergedChildren = nextPage == 1
        ? (res.result?.list ?? [])
        : [...existingChildren, ...(res.result?.list ?? [])];

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

    final res = await _repository.addComment(
      postId: post.postId,
      content: event.content.trim(),
      parentId: parentId,
      replyToCommentId: replyToCommentId,
    );

    if (res.code != 0 || res.result == null) {
      emit(state.copyWith(
        errorMessage: res.msg.isNotEmpty ? res.msg : '评论发送失败',
      ));
      return;
    }

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
    final res = await _repository.toggleLike(
      postId: post.postId,
      status: nextStatus,
    );
    if (res.code != 0) {
      emit(state.copyWith(
        errorMessage: res.msg.isNotEmpty ? res.msg : '操作失败',
      ));
      return;
    }

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
