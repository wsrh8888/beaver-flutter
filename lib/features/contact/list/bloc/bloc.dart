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
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/contact/list/bloc/event.dart';
import 'package:beaver/features/contact/list/bloc/state.dart';
import 'package:beaver/features/contact/list/data/repositories/repository.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/store/friend/friend_verify.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/store/user/user.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactListRepository _contactListRepository;
  final FriendStore _friendStore;
  final FriendVerifyStore _friendVerifyStore;
  StreamSubscription? _friendSubscription;
  StreamSubscription? _verifySubscription;

  ContactListBloc({
    ContactListRepository? contactListRepository,
    FriendStore? friendStore,
    FriendVerifyStore? friendVerifyStore,
  }) : _contactListRepository =
           contactListRepository ?? ContactListRepository(),
       _friendStore = friendStore ?? getIt<FriendStore>(),
       _friendVerifyStore = friendVerifyStore ?? getIt<FriendVerifyStore>(),
       super(const ContactListState()) {
    on<LoadContactListEvent>(_onLoadContactList);
    on<UpdateCurrentIndexEvent>(_onUpdateCurrentIndex);

    // --- 响应式联动 (Reactive Linkage) ---
    // 1. 监听全局 FriendStore，好友列表变更
    _friendSubscription = _friendStore.stream
        .map((state) => state.friends)
        .distinct()
        .listen((friends) {
          add(const LoadContactListEvent());
        });

    // 2. 监听全局 FriendVerifyStore，好友申请（红点）变更
    _verifySubscription = _friendVerifyStore.stream
        .map((state) => state.unreadCount)
        .distinct()
        .listen((count) {
          add(const LoadContactListEvent());
        });
  }

  @override
  Future<void> close() {
    _friendSubscription?.cancel();
    _verifySubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadContactList(
    LoadContactListEvent event,
    Emitter<ContactListState> emit,
  ) async {
    // 遵循规范：从 Global Store 获取已组装好的数据
    final contacts = _friendStore.state.friends;
    final currentUserId = getIt<UserStore>().state.currentUserId;

    final groupedContacts = _contactListRepository.groupContactsByLetter(
      contacts,
    );
    final indexList = _contactListRepository.getIndexList(groupedContacts);

    // 获取未读数
    int friendCount = 0;
    int groupCount = 0;
    if (currentUserId.isNotEmpty) {
      friendCount = await getIt<FriendBusiness>().getUnreadFriendRequestCount(
        currentUserId,
      );
      groupCount = await getIt<GroupBusiness>()
          .getUnreadGroupNotificationCount(currentUserId);
    }

    emit(
      state.copyWith(
        status: ContactListStatus.success,
        contacts: contacts,
        groupedContacts: groupedContacts,
        indexList: indexList,
        friendRequestCount: friendCount,
        groupNotificationCount: groupCount,
      ),
    );
  }

  void _onUpdateCurrentIndex(
    UpdateCurrentIndexEvent event,
    Emitter<ContactListState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }
}
