/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

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

  const FriendStoreState({this.friends = const []});

  FriendStoreState copyWith({List<ContactModel>? friends}) {
    return FriendStoreState(friends: friends ?? this.friends);
  }

  @override
  List<Object?> get props => [friends];
}

class FriendStore extends Cubit<FriendStoreState> {
  final FriendBusiness _friendBusiness;
  final ContactStore _contactStore;
  StreamSubscription? _contactSubscription;
  StreamSubscription? _friendBusinessSubscription;
  Timer? _initDebounceTimer;

  // 原始的好友基础记录（包含备注等）
  List<ContactModel> _rawFriends = [];
  bool _isInitialized = false;

  FriendStore({FriendBusiness? friendBusiness, ContactStore? contactStore})
    : _friendBusiness = friendBusiness ?? getIt<FriendBusiness>(),
      _contactStore = contactStore ?? getIt<ContactStore>(),
      super(const FriendStoreState()) {
    // 监听全局联系人变更，实时重组数据
    _contactSubscription = _contactStore.stream.listen((_) {
      // 只有初始化完成后，ContactStore 的变更才触发重组，避免初始碎片化通知
      if (_isInitialized && _rawFriends.isNotEmpty) {
        _reassemble();
      }
    });

    // 监听业务层好友变更通知，统一防抖刷新，避免同一批 WS 触发多次重载。
    _friendBusinessSubscription = _friendBusiness.friendUpdateStream.listen((
      _,
    ) {
      _debounceInit();
    });
  }

  void _debounceInit() {
    _initDebounceTimer?.cancel();
    _initDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      init();
    });
  }

  @override
  Future<void> close() {
    _contactSubscription?.cancel();
    _friendBusinessSubscription?.cancel();
    _initDebounceTimer?.cancel();
    return super.close();
  }

  /**
   * @description: 初始化，从业务层拉取原始好友列表并重组
   */
  Future<void> init() async {
    // 1. 获取包含备注（notice）的原始好友数据
    _rawFriends = await _friendBusiness.getContactList();

    // 2. 结合 ContactStore 元数据进行组装
    _isInitialized = true;
    _reassemble();
  }

  /**
   * @description: 数据重组逻辑 (Identity Resolution)
   * 结合 _rawFriends (备注/ID) 与 _contactStore (全局头像/昵称)
   */
  void _reassemble() {
    final userMap = _contactStore.state.userMap;

    final assembled = _rawFriends.map((friend) {
      final userInfo = userMap[friend.userId];

      final finalModel = friend.copyWith(
        // 这里的 nickname 指指的是全局最新的原始昵称 (对标 PC)
        nickname: userInfo?.nickname.isNotEmpty == true
            ? userInfo!.nickname
            : friend.nickname,
        // 这里的 avatar 指指的是全局最新的原始头像
        avatar: userInfo?.avatar ?? friend.avatar,
        // 这里的 notice 指指的是备注 (由 FriendBusiness 从数据库拉回)
        notice: friend.notice,
      );

      return finalModel;
    }).toList();

    emit(state.copyWith(friends: assembled));
  }

  /// 更新逻辑
  void updateFriends(List<ContactModel> newFriends) {
    _rawFriends = newFriends;
    _reassemble();
  }
}
