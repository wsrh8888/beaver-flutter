import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/types/business/contact.dart';

// 好友列表存储状态
class FriendStoreState extends Equatable {
  final List<ContactModel> friends;

  const FriendStoreState({
    this.friends = const [],
  });

  FriendStoreState copyWith({
    List<ContactModel>? friends,
  }) {
    return FriendStoreState(
      friends: friends ?? this.friends,
    );
  }

  @override
  List<Object?> get props => [friends];
}

class FriendStore extends Cubit<FriendStoreState> {
  final FriendBusiness _friendBusiness;
  final ContactStore _contactStore;
  StreamSubscription? _contactSubscription;

  // 原始的好友基础记录（包含备注等）
  List<ContactModel> _rawFriends = [];

  FriendStore({FriendBusiness? friendBusiness, ContactStore? contactStore})
    : _friendBusiness = friendBusiness ?? getIt<FriendBusiness>(),
      _contactStore = contactStore ?? getIt<ContactStore>(),
      super(const FriendStoreState()) {
    // 监听全局联系人变更，实时重组数据
    _contactSubscription = _contactStore.stream.listen((_) {
      _reassemble();
    });
  }

  @override
  Future<void> close() {
    _contactSubscription?.cancel();
    return super.close();
  }

  /**
   * @description: 初始化，从业务层拉取原始好友列表并重组
   */
  Future<void> init() async {
    try {
      // 1. 获取包含备注（notice）的原始好友数据
      _rawFriends = await _friendBusiness.getContactList();
      print('FriendStore: 从 Business 获取到原始好友记录: ${_rawFriends.length} 条');

      // 2. 结合 ContactStore 元数据进行组装
      _reassemble();

      print('FriendStore: 初始化且组装完成，好友总数: ${_rawFriends.length}');
    } catch (e) {
      print('FriendStore: 初始化失败: $e');
    }
  }

  /**
   * @description: 数据重组逻辑 (Identity Resolution)
   * 结合 _rawFriends (备注/ID) 与 _contactStore (全局头像/昵称)
   */
  void _reassemble() {
    final userMap = _contactStore.state.userMap;

    final assembled = _rawFriends.map((friend) {
      final userInfo = userMap[friend.userId];

      print('FriendStore: _reassemble -----------------------------------');
      print('  - userId: ${friend.userId}');
      print(
        '  - 原始 (Business): nickname: ${friend.nickname}, notice: ${friend.notice}, avatar: ${friend.avatar}',
      );
      print(
        '  - 关联 (ContactStore): ${userInfo != null ? "命中 (nickname: ${userInfo.nickname}, avatar: ${userInfo.avatar})" : "未命中"}',
      );

      final finalModel = friend.copyWith(
        // 这里的 nickname 指的是全局最新的原始昵称 (对标 PC)
        nickname: userInfo?.nickname.isNotEmpty == true
            ? userInfo!.nickname
            : friend.nickname,
        // 这里的 avatar 指的是全局最新的原始头像
        avatar: userInfo?.avatar ?? friend.avatar,
        // 这里的 notice 指的是备注 (由 FriendBusiness 从数据库拉回)
        notice: friend.notice,
      );

      print(
        '  - 最终 (Assembled): nickname: ${finalModel.nickname}, notice: ${finalModel.notice}, avatar: ${finalModel.avatar}',
      );
      return finalModel;
    }).toList();

    print('FriendStore: _reassemble 完成，最终列表长度: ${assembled.length}');

    emit(state.copyWith(friends: assembled));
  }

  /// 更新逻辑
  void updateFriends(List<ContactModel> newFriends) {
    _rawFriends = newFriends;
    _reassemble();
  }
}
