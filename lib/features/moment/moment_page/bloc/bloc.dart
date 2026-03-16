import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/moment/moment_page/bloc/event.dart';
import 'package:beaver/features/moment/moment_page/bloc/state.dart';
import 'package:beaver/features/moment/moment_page/data/repositories/repository.dart';

class MomentBloc extends Bloc<MomentEvent, MomentState> {
  final MomentRepository _repository;
  String _currentUserId = '1';

  MomentBloc(this._repository) : super(const MomentState()) {
    on<LoadMomentsEvent>(_onLoadMoments);
    on<ToggleLikeEvent>(_onToggleLike);
    on<PreviewImageEvent>(_onPreviewImage);
    on<GoToPostEvent>(_onGoToPost);
  }

  Future<void> _onLoadMoments(
    LoadMomentsEvent event,
    Emitter<MomentState> emit,
  ) async {
    emit(state.copyWith(status: MomentStatus.loading));

    try {
      final moments = await _repository.getMoments();
      emit(state.copyWith(
        status: MomentStatus.success,
        moments: moments,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MomentStatus.error,
        errorMessage: '加载朋友圈失败: $e',
      ));
    }
  }

  Future<void> _onToggleLike(
    ToggleLikeEvent event,
    Emitter<MomentState> emit,
  ) async {
    try {
      await _repository.toggleLike(event.momentId, event.status);

      final updatedMoments = state.moments.map((moment) {
        if (moment.id == event.momentId) {
          final updatedLikes = List<MomentLike>.from(moment.likes);
          if (event.status) {
            updatedLikes.add(MomentLike(_currentUserId, '当前用户'));
          } else {
            updatedLikes.removeWhere((like) => like.userId == _currentUserId);
          }
          return moment.copyWith(likes: updatedLikes);
        }
        return moment;
      }).toList();

      emit(state.copyWith(moments: updatedMoments));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '点赞操作失败: $e',
      ));
    }
  }

  Future<void> _onPreviewImage(
    PreviewImageEvent event,
    Emitter<MomentState> emit,
  ) async {
    // 图片预览逻辑
  }

  Future<void> _onGoToPost(
    GoToPostEvent event,
    Emitter<MomentState> emit,
  ) async {
    // 导航到发布动态页面
  }
}
