import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/types/business/contact.dart';

// 好友列表存储状态
class FriendStoreState extends Equatable {
  final List<ContactModel> friends;
  final List<dynamic> friendRequests;

  const FriendStoreState({
    this.friends = const [],
    this.friendRequests = const [],
  });

  FriendStoreState copyWith({
    List<ContactModel>? friends,
    List<dynamic>? friendRequests,
  }) {
    return FriendStoreState(
      friends: friends ?? this.friends,
      friendRequests: friendRequests ?? this.friendRequests,
    );
  }

  @override
  List<Object?> get props => [friends, friendRequests];
}

class FriendStore extends Cubit<FriendStoreState> {
  final FriendBusiness _friendBusiness;
  
  FriendStore({FriendBusiness? friendBusiness}) 
    : _friendBusiness = friendBusiness ?? getIt<FriendBusiness>(),
      super(const FriendStoreState());

  /**
   * @description: 初始化，加载好友列表与申请列表
   */
  Future<void> init() async {
    try {
      final friends = await _friendBusiness.getContactList();
      emit(state.copyWith(
        friends: friends,
      ));
      print('FriendStore: 初始化完成，好友总数: ${friends.length}');
    } catch (e) {
      print('FriendStore: 初始化失败: $e');
    }
  }

  /// 这里的 Logic 可以扩展：添加新好友、响应确认等
  void updateFriends(List<ContactModel> newFriends) {
    emit(state.copyWith(friends: newFriends));
  }
}
