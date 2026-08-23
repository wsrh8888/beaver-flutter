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
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/circle/circle.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/group/group.dart';
import 'package:beaver/types/business/chat.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatStoreState extends Equatable {
  final List<ChatModel> conversations;
  final int totalUnreadCount;

  const ChatStoreState({
    this.conversations = const [],
    this.totalUnreadCount = 0,
  });

  ChatStoreState copyWith({
    List<ChatModel>? conversations,
    int? totalUnreadCount,
  }) {
    return ChatStoreState(
      conversations: conversations ?? this.conversations,
      totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
    );
  }

  @override
  List<Object?> get props => [conversations, totalUnreadCount];
}

class ChatStore extends Cubit<ChatStoreState> {
  final ConversationBusiness _conversationBusiness;
  final GroupStore _groupStore;
  final CircleStore _circleStore;
  final ContactStore _contactStore;
  StreamSubscription? _groupSubscription;
  StreamSubscription? _circleSubscription;
  StreamSubscription? _contactSubscription;
  StreamSubscription? _conversationBusinessSubscription;
  Timer? _initDebounceTimer;

  ChatStore({
    ConversationBusiness? conversationBusiness,
    GroupStore? groupStore,
    CircleStore? circleStore,
    ContactStore? contactStore,
  }) : _conversationBusiness =
            conversationBusiness ?? getIt<ConversationBusiness>(),
       _groupStore = groupStore ?? getIt<GroupStore>(),
       _circleStore = circleStore ?? getIt<CircleStore>(),
       _contactStore = contactStore ?? getIt<ContactStore>(),
       super(const ChatStoreState()) {
    // 监听群组 / 圈子 / 联系人 Store，实现响应式重组 (对标 PC 的 Computed Getters)
    _groupSubscription = _groupStore.stream.listen((_) => _onStoreUpdate());
    _circleSubscription = _circleStore.stream.listen((_) => _onStoreUpdate());
    _contactSubscription = _contactStore.stream.listen((_) => _onStoreUpdate());

    // 监听业务层会话流，实现响应式初始化 (防抖处理，避免 WS 批量推送时高频刷新)
    _conversationBusinessSubscription =
        _conversationBusiness.conversationUpdateStream.listen((_) {
      _debounceInit();
    });

    // 首次载入
    init();
  }

  void _debounceInit() {
    _initDebounceTimer?.cancel();
    _initDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      init();
    });
  }

  @override
  Future<void> close() {
    _groupSubscription?.cancel();
    _circleSubscription?.cancel();
    _contactSubscription?.cancel();
    _conversationBusinessSubscription?.cancel();
    _initDebounceTimer?.cancel();
    return super.close();
  }

  /// 当关联 Store 更新时，本地逻辑“重写”头像和昵称，确保 UI 始终显示最新资料
  void _onStoreUpdate() {
    if (state.conversations.isEmpty) return;

    final updatedConversations = state.conversations.map((conv) {
      var newConv = conv;
      final conversationId = conv.conversationId;

      if (conversationId.startsWith('group_')) {
        final groupInfo = _groupStore.getGroup(conversationId);
        if (groupInfo != null) {
          if (newConv.avatar != groupInfo.avatar ||
              newConv.nickname != groupInfo.title) {
            newConv = newConv.copyWith(
              avatar: groupInfo.avatar,
              nickname: groupInfo.title,
            );
          }
        }
      } else if (conversationId.startsWith('circle_')) {
        final circleInfo = _circleStore.getCircle(conversationId);
        if (circleInfo != null) {
          final name =
              circleInfo.name.isNotEmpty ? circleInfo.name : '圈子';
          if (newConv.avatar != circleInfo.avatar ||
              newConv.nickname != name) {
            newConv = newConv.copyWith(
              avatar: circleInfo.avatar,
              nickname: name,
            );
          }
        } else if (newConv.nickname.isEmpty) {
          newConv = newConv.copyWith(nickname: '圈子');
        }
      } else if (conversationId.startsWith('private_')) {
        // 私聊逻辑：解析出对方 userId，从 ContactStore 获取最新头像/备注
        final parts = conversationId.split('_');
        if (parts.length >= 3) {
          final currentUserId = DatabaseManager.currentUserId ?? '';
          final otherUserId = (parts[1] == currentUserId) ? parts[2] : parts[1];
          final contactInfo = _contactStore.getContact(otherUserId);
          if (contactInfo != null) {
            // 优先级：ContactStore 记录（包含备注和最新头像）
            final newAvatar = contactInfo.avatar ?? newConv.avatar;
            final newNickname = contactInfo.nickname; // 这里可以根据是否有备注逻辑微调
            if (newConv.avatar != newAvatar ||
                newConv.nickname != newNickname) {
              newConv = newConv.copyWith(
                avatar: newAvatar,
                nickname: newNickname,
              );
            }
          }
        }
      }
      return newConv;
    }).toList();

    // 只有在数据真正发生变化时才 emit，避免无限循环
    if (updatedConversations != state.conversations) {
      emit(state.copyWith(conversations: updatedConversations));
    }
  }

  Future<void> init() async {
    try {
      final conversations = await _conversationBusiness.getChatList();

      var totalUnread = 0;
      for (final conv in conversations) {
        totalUnread += conv.unreadCount;
      }

      emit(
        state.copyWith(
          conversations: conversations,
          totalUnreadCount: totalUnread,
        ),
      );
      _onStoreUpdate();
    } catch (e) {
      print('ChatStore: init failed: $e');
    }
  }

  Future<void> togglePinChat(String conversationId, bool isPinned) async {
    await _conversationBusiness.togglePinChat(conversationId, isPinned);
    await init();
  }

  Future<void> deleteChat(String conversationId) async {
    await _conversationBusiness.deleteChat(conversationId);
    await init();
  }

  Future<void> markAsRead(String conversationId) async {
    await _conversationBusiness.markAsRead(conversationId);
    // Business 层已经调用了 init()，这里为了双重保险也可以再调一次，或者依赖 Business 层的通知。
  }

  void updateTotalUnreadCount(int count) {
    emit(state.copyWith(totalUnreadCount: count));
  }
}
