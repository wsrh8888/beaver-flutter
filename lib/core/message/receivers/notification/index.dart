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

import './event_receiver.dart';
import './inbox_receiver.dart';
import './read_cursor_receiver.dart';

/// 通知消息路由器 (对标 PC receivers/notification/index.ts)
class NotificationMessageRouter {
  final _eventReceiver = eventReceiver;
  final _inboxReceiver = inboxReceiver;
  final _readCursorReceiver = readCursorReceiver;

  /**
   * 处理通知消息
   * @param wsMessage WebSocket 消息内容
   */
  Future<void> processNotificationMessage(
    Map<String, dynamic> wsMessage,
  ) async {
    final data = wsMessage['data'] as Map<String, dynamic>?;

    if (data == null) {
      print('[NotificationMessageRouter] 收到通知消息, 但缺少 data 字段: $wsMessage');
      return;
    }

    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (type == null || body == null) return;

    switch (type) {
      // 通知推送消息
      case 'notification_receive':
        await _inboxReceiver.handleTableUpdates(body);
        await _readCursorReceiver.handleTableUpdates(body);
        await _eventReceiver.handleTableUpdates(body);
        break;

      // 标记已读同步消息
      case 'notification_mark_read_receive':
        await _readCursorReceiver.handleTableUpdates(body);
        break;

      default:
        print('[NotificationMessageRouter] 未知的通知消息类型: $type');
    }
  }
}

final notificationMessageRouter = NotificationMessageRouter();
