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

import './user.dart';

/// User message router.
class UserMessageRouter {
  final _userReceiver = userReceiver;

  /**
   * 处理用户消息
   * @param wsMessage WebSocket 消息内容
   */
  Future<void> processUserMessage(Map<String, dynamic> wsMessage) async {
    final data = wsMessage['data'] as Map<String, dynamic>?;

    if (data == null) {
      print('[UserMessageRouter] 收到用户消息, 但缺少 data 字段: $wsMessage');
      return;
    }

    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (type == null || body == null) return;

    switch (type) {
      case 'user_receive':
        await _userReceiver.handleTableUpdates(body);
        break;
      default:
        break;
    }
  }
}

final userMessageRouter = UserMessageRouter();
