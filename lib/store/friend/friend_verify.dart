import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/business/friend/friend_verify.dart';
import 'package:beaver/core/database/db.dart';

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
  final FriendVerifyBusiness _friendVerifyBusiness;
  StreamSubscription? _verifySubscription;

  FriendVerifyStore({
    FriendBusiness? friendBusiness,
    FriendVerifyBusiness? friendVerifyBusiness,
  }) : _friendBusiness = friendBusiness ?? getIt<FriendBusiness>(),
       _friendVerifyBusiness =
           friendVerifyBusiness ?? getIt<FriendVerifyBusiness>(),
       super(const FriendVerifyStoreState()) {
    // 监听好友申请增量推送
    _verifySubscription = _friendVerifyBusiness.verifyUpdateStream.listen((_) {
      refresh();
    });
  }

  @override
  Future<void> close() {
    _verifySubscription?.cancel();
    return super.close();
  }

  Future<void> init() async {
    try {
      final currentUserId = DatabaseManager.currentUserId ?? '';
      final requests = await _friendBusiness.getFriendRequests();
      final unreadCount = await _friendBusiness.getUnreadFriendRequestCount(
        currentUserId,
      );
      emit(
        state.copyWith(friendVerifyList: requests, unreadCount: unreadCount),
      );
    } catch (e) {
      print('FriendVerifyStore: 初始化失败: $e');
    }
  }

  Future<void> refresh() async {
    await init();
  }
}
