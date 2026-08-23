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

import 'package:beaver/core/business/notification/inbox.dart';
import 'package:beaver/di/injection.dart';

/// 通知收件箱接收器 - 处理 notification_inbox 表的操作 (对标 PC receivers/notification/inbox-receiver.ts)
class InboxReceiver {
  NotificationInboxBusiness get _inboxBusiness => getIt<NotificationInboxBusiness>();

  /**
   * 处理通知收件箱更新通知
   */
  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final updates = (body['tableUpdates'] ?? body['tables']) as List?;
    if (updates == null) return;

    for (final update in updates) {
      final table = update['table'] as String?;
      final data = update['data'] as List?;
      final userId = update['userId'] as String?;

      if (table != 'notification_inbox' || data == null || userId == null) {
        continue;
      }

      for (final item in data) {
        final version = item['version'] as int?;
        final eventId = item['eventId'] as String?;
        if (version != null && eventId != null) {
          await _inboxBusiness.handleTableUpdates(version, eventId, userId);
        }
      }
    }
  }
}

final inboxReceiver = InboxReceiver();
