import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/contact/new_friends/bloc/event.dart';
import 'package:beaver/features/contact/new_friends/bloc/state.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/features/contact/new_friends/data/repositories/repository.dart';

class NewFriendsBloc extends Bloc<NewFriendsEvent, NewFriendsState> {
  final NewFriendsRepository _repository = NewFriendsRepository();

  NewFriendsBloc() : super(const NewFriendsState()) {
    on<LoadFriendRequestsEvent>(_onLoadFriendRequests);
    on<SwitchTabEvent>(_onSwitchTab);
    on<AcceptRequestEvent>(_onAcceptRequest);
    on<RejectRequestEvent>(_onRejectRequest);
  }

  Future<void> _onLoadFriendRequests(
    LoadFriendRequestsEvent event,
    Emitter<NewFriendsState> emit,
  ) async {
    emit(state.copyWith(status: NewFriendsStatus.loading));

    try {
      final friendRequests = await _repository.getFriendRequests();
      emit(state.copyWith(
        status: NewFriendsStatus.success,
        friendRequests: friendRequests,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NewFriendsStatus.error,
        errorMessage: '加载好友申请失败: $e',
      ));
    }
  }

  Future<void> _onSwitchTab(
    SwitchTabEvent event,
    Emitter<NewFriendsState> emit,
  ) async {
    emit(state.copyWith(activeTab: event.tab));
  }

  Future<void> _onAcceptRequest(
    AcceptRequestEvent event,
    Emitter<NewFriendsState> emit,
  ) async {
    emit(state.copyWith(status: NewFriendsStatus.loading));

    try {
      await _repository.updateRequestStatus(event.id, 1);
      final updatedRequests = state.friendRequests.map((request) {
        if (request.id == event.id) {
          return FriendRequest(
            id: request.id,
            nickname: request.nickname,
            fileName: request.fileName,
            message: request.message,
            source: request.source,
            flag: request.flag,
            status: 1,
            createdAt: request.createdAt,
          );
        }
        return request;
      }).toList();
      emit(state.copyWith(
        status: NewFriendsStatus.success,
        friendRequests: updatedRequests,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NewFriendsStatus.error,
        errorMessage: '接受好友申请失败: $e',
      ));
    }
  }

  Future<void> _onRejectRequest(
    RejectRequestEvent event,
    Emitter<NewFriendsState> emit,
  ) async {
    emit(state.copyWith(status: NewFriendsStatus.loading));

    try {
      await _repository.updateRequestStatus(event.id, 2);
      final updatedRequests = state.friendRequests.map((request) {
        if (request.id == event.id) {
          return FriendRequest(
            id: request.id,
            nickname: request.nickname,
            fileName: request.fileName,
            message: request.message,
            source: request.source,
            flag: request.flag,
            status: 2,
            createdAt: request.createdAt,
          );
        }
        return request;
      }).toList();
      emit(state.copyWith(
        status: NewFriendsStatus.success,
        friendRequests: updatedRequests,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NewFriendsStatus.error,
        errorMessage: '拒绝好友申请失败: $e',
      ));
    }
  }
}

