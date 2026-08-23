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

import 'package:beaver/core/business/notification/event.dart';
import 'package:beaver/di/injection.dart';

/// 通知事件接收器 - 处理 notification_event 表的操作 (对标 PC receivers/notification/event-receiver.ts)
class EventReceiver {
  NotificationEventBusiness get _eventBusiness => getIt<NotificationEventBusiness>();

  /**
   * 处理通知事件更新通知
   */
  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final updates = (body['tableUpdates'] ?? body['tables']) as List?;
    if (updates == null) return;

    for (final update in updates) {
      final table = update['table'] as String?;
      final data = update['data'] as List?;

      if (table == 'notification_event' && data != null) {
        for (final item in data) {
          final eventId = item['eventId'] as String?;
          if (eventId != null) {
            await _eventBusiness.handleTableUpdates(eventId);
          }
        }
      }
    }
  }
}

final eventReceiver = EventReceiver();
