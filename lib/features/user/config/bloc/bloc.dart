import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/user/config/bloc/event.dart';
import 'package:beaver/features/user/config/bloc/state.dart';
import 'package:beaver/features/user/config/data/repositories/repository.dart';

class UserConfigBloc extends Bloc<UserConfigEvent, UserConfigState> {
  final UserConfigRepository _repository;

  UserConfigBloc(this._repository) : super(const UserConfigState()) {
    on<LoadFriendInfoEvent>(_onLoadFriendInfo);
    on<ToggleTopChatEvent>(_onToggleTopChat);
    on<ShowDeleteModalEvent>(_onShowDeleteModal);
    on<HideDeleteModalEvent>(_onHideDeleteModal);
    on<ConfirmDeleteEvent>(_onConfirmDelete);
  }

  Future<void> _onLoadFriendInfo(
    LoadFriendInfoEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    emit(state.copyWith(
      status: UserConfigStatus.loading,
      conversationId: event.conversationId,
    ));
    try {
      final info = await _repository.getFriendInfo(event.conversationId);
      emit(state.copyWith(
        status: UserConfigStatus.success,
        friendInfo: info,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleTopChat(
    ToggleTopChatEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    final oldStatus = state.isTopChat;
    final newStatus = !oldStatus;
    emit(state.copyWith(isTopChat: newStatus));
    
    try {
      final success = await _repository.toggleTopChat(state.conversationId, newStatus);
      if (!success) {
        emit(state.copyWith(isTopChat: oldStatus, errorMessage: '操作失败'));
      }
    } catch (e) {
      emit(state.copyWith(isTopChat: oldStatus, errorMessage: e.toString()));
    }
  }

  void _onShowDeleteModal(
    ShowDeleteModalEvent event,
    Emitter<UserConfigState> emit,
  ) {
    emit(state.copyWith(showDeleteModal: true));
  }

  void _onHideDeleteModal(
    HideDeleteModalEvent event,
    Emitter<UserConfigState> emit,
  ) {
    emit(state.copyWith(showDeleteModal: false));
  }

  Future<void> _onConfirmDelete(
    ConfirmDeleteEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    if (state.friendInfo == null) return;
    
    emit(state.copyWith(status: UserConfigStatus.loading));
    try {
      final success = await _repository.deleteFriend(state.friendInfo!.userId);
      if (success) {
        emit(state.copyWith(showDeleteModal: false, status: UserConfigStatus.success));
      } else {
        emit(state.copyWith(
          status: UserConfigStatus.error,
          errorMessage: '删除失败',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: UserConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
