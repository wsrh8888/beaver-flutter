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
