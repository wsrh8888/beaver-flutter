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
      final friendInfo = await _repository.getFriendInfo(event.conversationId);
      emit(state.copyWith(
        status: UserConfigStatus.success,
        friendInfo: friendInfo,
        isTopChat: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserConfigStatus.error,
        errorMessage: '加载好友信息失败: $e',
      ));
    }
  }

  Future<void> _onToggleTopChat(
    ToggleTopChatEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    try {
      final newStatus = !state.isTopChat;
      await _repository.toggleTopChat(state.conversationId, newStatus);
      emit(state.copyWith(
        isTopChat: newStatus,
        errorMessage: newStatus ? '已置�? : '已取消置�?,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '操作失败: $e',
      ));
    }
  }

  Future<void> _onShowDeleteModal(
    ShowDeleteModalEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    emit(state.copyWith(showDeleteModal: true));
  }

  Future<void> _onHideDeleteModal(
    HideDeleteModalEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    emit(state.copyWith(showDeleteModal: false));
  }

  Future<void> _onConfirmDelete(
    ConfirmDeleteEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    if (state.friendInfo == null) return;

    emit(state.copyWith(status: UserConfigStatus.loading));

    try {
      await _repository.deleteFriend(state.friendInfo!.userId);
      emit(state.copyWith(
        status: UserConfigStatus.success,
        showDeleteModal: false,
        errorMessage: '删除成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserConfigStatus.error,
        errorMessage: '删除失败: $e',
      ));
    }
  }
}

