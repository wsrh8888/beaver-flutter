import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/user/config/bloc/event.dart';
import 'package:beaver/features/user/config/bloc/state.dart';
import 'package:beaver/features/user/config/data/repositories/repository.dart';

class UserConfigBloc extends Bloc<UserConfigEvent, UserConfigState> {
  final UserConfigRepository _repository;

  UserConfigBloc(this._repository) : super(const UserConfigState()) {
    on<LoadUserConfigEvent>(_onLoadUserConfig);
    on<ToggleStickyEvent>(_onToggleSticky);
    on<ToggleMuteEvent>(_onToggleMute);
  }

  Future<void> _onLoadUserConfig(
    LoadUserConfigEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    emit(state.copyWith(status: UserConfigStatus.loading));
    try {
      final config = await _repository.getUserConfig(event.userId);
      emit(state.copyWith(
        status: UserConfigStatus.success,
        isSticky: config.isSticky,
        isMute: config.isMute,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleSticky(
    ToggleStickyEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    final oldStatus = state.isSticky;
    final newStatus = !oldStatus;
    emit(state.copyWith(isSticky: newStatus));
    
    try {
      final success = await _repository.updateSticky(event.userId, newStatus);
      if (!success) {
        emit(state.copyWith(isSticky: oldStatus, errorMessage: '操作失败'));
      } else {
        emit(state.copyWith(errorMessage: newStatus ? '已置顶' : '已取消置顶'));
      }
    } catch (e) {
      emit(state.copyWith(isSticky: oldStatus, errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleMute(
    ToggleMuteEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    final oldStatus = state.isMute;
    final newStatus = !oldStatus;
    emit(state.copyWith(isMute: newStatus));
    
    try {
      final success = await _repository.updateMute(event.userId, newStatus);
      if (!success) {
        emit(state.copyWith(isMute: oldStatus, errorMessage: '操作失败'));
      }
    } catch (e) {
      emit(state.copyWith(isMute: oldStatus, errorMessage: e.toString()));
    }
  }
}
