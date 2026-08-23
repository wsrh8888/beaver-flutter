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

import 'package:beaver/features/chat/list/list.dart';
import 'package:beaver/features/chat/detail/detail.dart';
import 'package:beaver/features/chat/forward_picker/picker_page.dart';
import 'package:beaver/features/chat/forward_detail/detail_page.dart';
import 'package:beaver/features/common/select_conversation/select_conversation_page.dart';
import 'package:beaver/features/chat/private_setting/private_setting.dart';
import 'package:beaver/features/chat/group_setting/group_setting.dart';
import 'package:beaver/router/routes.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> chatRoutes() {
  return [
    GoRoute(
      path: AppRoutes.chatList,
      builder: (context, state) => const ChatListPage(),
    ),
    GoRoute(
      path: AppRoutes.chatDetail,
      builder: (context, state) {
        final idFromQuery = state.uri.queryParameters['id'];
        final idFromExtra = state.extra is String ? state.extra as String : null;
        final conversationId = idFromQuery ?? idFromExtra;
        return ChatDetailPage(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: AppRoutes.privateChatSetting,
      builder: (context, state) {
        final idFromQuery = state.uri.queryParameters['id'];
        final idFromExtra = state.extra is String ? state.extra as String : null;
        final conversationId = idFromQuery ?? idFromExtra;
        return PrivateSettingPage(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: AppRoutes.groupChatSetting,
      builder: (context, state) {
        final idFromQuery = state.uri.queryParameters['id'];
        final idFromExtra = state.extra is String ? state.extra as String : null;
        final conversationId = idFromQuery ?? idFromExtra;
        return GroupSettingPage(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: AppRoutes.chatForward,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final messageIds = extra?['messageIds'] as List<String>? ?? [];
        final forwardMode = extra?['forwardMode'] as int? ?? 1;
        return ForwardPickerPage(
          messageIds: messageIds,
          forwardMode: forwardMode,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.chatForwardDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final title = extra?['title'] as String? ?? '聊天记录';
        final recordId = extra?['recordId'] as String?;
        return ForwardDetailPage(title: title, recordId: recordId);
      },
    ),
    // 兼容旧路由：转发到通用选会话页
    GoRoute(
      path: AppRoutes.chatShareConversation,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final hasNested = extra.containsKey('payload');
        return SelectConversationPage(
          title: extra['title'] as String? ?? '选择会话',
          payload: hasNested
              ? extra['payload'] as Map<String, dynamic>?
              : extra,
        );
      },
    ),
  ];
}
