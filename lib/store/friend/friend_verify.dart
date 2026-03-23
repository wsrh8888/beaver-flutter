import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/friend/friend.dart';

class FriendVerifyStoreState extends Equatable {
  final List<dynamic> friendVerifyList;
  final int unreadCount;

  const FriendVerifyStoreState({
    this.friendVerifyList = const [],
    this.unreadCount = 0,
  });

  FriendVerifyStoreState copyWith({
    List<dynamic>? friendVerifyList,
    int? unreadCount,
  }) {
    return FriendVerifyStoreState(
      friendVerifyList: friendVerifyList ?? this.friendVerifyList,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [friendVerifyList, unreadCount];
}

class FriendVerifyStore extends Cubit<FriendVerifyStoreState> {
  final FriendBusiness _friendBusiness;

  FriendVerifyStore({FriendBusiness? friendBusiness})
    : _friendBusiness = friendBusiness ?? getIt<FriendBusiness>(),
      super(const FriendVerifyStoreState());

  Future<void> init() async {
    try {
      final requests = await _friendBusiness.getFriendRequests();
      final unreadCount = await _friendBusiness.getUnreadFriendRequestCount('');
      emit(state.copyWith(
        friendVerifyList: requests,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      print('FriendVerifyStore: 初始化失败: $e');
    }
  }

  Future<void> handleFriendVerify(int requestId, int status) async {
    try {
      await _friendBusiness.updateFriendRequestStatus(requestId, status);
      await refresh();
    } catch (e) {
      print('FriendVerifyStore: 处理好友验证失败: $e');
    }
  }

  Future<void> refresh() async {
    await init();
  }
}
