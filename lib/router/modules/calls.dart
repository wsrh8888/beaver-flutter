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

import 'package:go_router/go_router.dart';
import 'package:beaver/features/calls/calls_page/calls_page.dart';
import 'package:beaver/features/calls/call/call_page.dart';
import 'package:beaver/features/calls/incoming/call_incoming.dart';
import 'package:beaver/types/call.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> callsRoutes() {
  return [
    GoRoute(
      path: AppRoutes.callsPage,
      builder: (context, state) => const CallsPage(),
    ),
    GoRoute(
      path: AppRoutes.call,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final callTypeStr = extras?['callType'] as String? ?? 'audio';
        final callType = callTypeStr == 'video' ? CallType.video : CallType.audio;
        return CallPage(
          conversationId: extras?['conversationId'] ?? '',
          roomToken: extras?['roomToken'] ?? '',
          liveKitUrl: extras?['liveKitUrl'] ?? '',
          callType: callType,
          isGroup: extras?['isGroup'] ?? extras?['conversationId']?.startsWith('group_') ?? false,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.callIncoming,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        return CallInvitationPage(
          conversationId: extras?['conversationId'] ?? '',
          roomId: extras?['roomId'] ?? '',
        );
      },
    ),
  ];
}
