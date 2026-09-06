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
import 'package:beaver/core/business/friend/friend_verify.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('friend-verify');

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
      _logger.error({
        'text': '好友验证列表初始化失败',
        'data': {'error': e.toString()},
      });
    }
  }

  Future<void> refresh() async {
    await init();
  }
}
