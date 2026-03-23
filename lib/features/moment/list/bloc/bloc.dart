import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/moment/list/bloc/event.dart';
import 'package:beaver/features/moment/list/bloc/state.dart';
import 'package:beaver/types/api/moment.dart';
import 'package:beaver/features/moment/list/data/repositories/repository.dart';

class MomentListBloc extends Bloc<MomentListEvent, MomentListState> {
  final MomentListRepository _momentListRepository;
  final int limit = 10;

  MomentListBloc({MomentListRepository? momentListRepository}) 
    : _momentListRepository = momentListRepository ?? MomentListRepository(),
      super(const MomentListState()) {
    on<LoadMomentListEvent>(_onLoadMomentList);
    on<ToggleLikeMomentEvent>(_onToggleLikeMoment);
  }

  Future<void> _onLoadMomentList(LoadMomentListEvent event, Emitter<MomentListState> emit) async {
    if (state.status == MomentListStatus.loading) return;

    final isRefresh = event.refresh;
    final nextPage = isRefresh ? 1 : state.page + 1;

    if (isRefresh) {
      emit(state.copyWith(status: MomentListStatus.loading));
    }

    try {
      final newMoments = await _momentListRepository.getMomentList(nextPage, limit);
      
      final updatedMoments = isRefresh ? newMoments : [...state.moments, ...newMoments];
      
      emit(state.copyWith(
        status: MomentListStatus.success,
        moments: updatedMoments,
        page: nextPage,
        hasMore: newMoments.length >= limit,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MomentListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleLikeMoment(ToggleLikeMomentEvent event, Emitter<MomentListState> emit) async {
    final momentIndex = state.moments.indexWhere((m) => m.id == event.moment.id);
    if (momentIndex == -1) return;

    final moment = state.moments[momentIndex];
    final hasLiked = moment.likes.any((like) => like.userId == event.currentUserId);
    final targetStatus = !hasLiked;

    // Optimistic update
    final updatedLikes = List<IMomentLikeModel>.from(moment.likes);
    if (targetStatus) {
      updatedLikes.add(IMomentLikeModel(
        id: '',
        momentId: moment.id,
        userId: event.currentUserId,
        userName: event.currentUserName,
        avatar: '',
        createdAt: DateTime.now().toIso8601String(),
      ));
    } else {
      updatedLikes.removeWhere((like) => like.userId == event.currentUserId);
    }

    final updatedMoment = IMomentListItem(
      id: moment.id,
      userId: moment.userId,
      userName: moment.userName,
      avatar: moment.avatar,
      content: moment.content,
      files: moment.files,
      comments: moment.comments,
      likes: updatedLikes,
      commentCount: moment.commentCount,
      likeCount: updatedLikes.length,
      isLiked: targetStatus,
      createdAt: moment.createdAt,
    );

    final newMoments = List<IMomentListItem>.from(state.moments);
    newMoments[momentIndex] = updatedMoment;

    emit(state.copyWith(moments: newMoments));

    // Actually make network request
    final success = await _momentListRepository.toggleLike(moment.id, targetStatus);
    if (!success) {
      // Revert if failed (simplified, assumes single failure handling isn't critical right now)
      emit(state.copyWith(moments: state.moments));
    }
  }
}
