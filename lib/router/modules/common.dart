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
import 'package:beaver/features/common/webview/webview.dart';
import 'package:beaver/features/common/scan/scan.dart';
import 'package:beaver/features/common/share/share_args.dart';
import 'package:beaver/features/common/share/share_page.dart';
import 'package:beaver/features/common/select_conversation/select_conversation_page.dart';
import 'package:beaver/features/common/select_friend/select_friend_page.dart';
import 'package:beaver/router/routes.dart';
import 'package:flutter/material.dart';

List<GoRoute> commonRoutes() {
  return [
    GoRoute(
      path: AppRoutes.webview,
      builder: (context, state) {
        final url = state.uri.queryParameters['url'] ?? '';
        final title = state.uri.queryParameters['title'];
        return WebViewPage(url: url, title: title);
      },
    ),
    GoRoute(
      path: AppRoutes.scan,
      builder: (context, state) => const ScanPage(),
    ),
    GoRoute(
      path: AppRoutes.entityShare,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is EntityShareArgs) {
          return EntitySharePage(args: extra);
        }
        return const Scaffold(
          body: Center(child: Text('分享参数无效')),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.selectFriend,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return SelectFriendPage(
          title: extra['title'] as String? ?? '选择好友',
          disabledUserIds:
              (extra['disabledUserIds'] as List?)?.cast<String>() ?? const [],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.selectConversation,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return SelectConversationPage(
          title: extra['title'] as String? ?? '选择会话',
          payload: extra['payload'] as Map<String, dynamic>?,
        );
      },
    ),
  ];
}
