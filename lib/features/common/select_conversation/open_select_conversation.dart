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

import 'package:beaver/features/common/select_conversation/select_conversation_page.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/types/business/chat.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 打开选择会话页
///
/// - [payload] 不为空：发送消息模式，成功返回 `true`
/// - [payload] 为空：选择模式，返回 [ChatModel]
Future<T?> openSelectConversation<T>(
  BuildContext context, {
  String title = '选择会话',
  Map<String, dynamic>? payload,
}) {
  if (payload != null) {
    return context.push<T>(
      AppRoutes.selectConversation,
      extra: {
        'title': title,
        'payload': payload,
      },
    );
  }

  return Navigator.of(context).push<T>(
    MaterialPageRoute(
      builder: (_) => SelectConversationPage(title: title),
    ),
  );
}
