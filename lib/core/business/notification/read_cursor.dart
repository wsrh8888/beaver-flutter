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

import 'package:beaver/api/notification.dart';
import 'package:beaver/core/business/notification/inbox.dart';
import 'package:beaver/core/database/services/notification/read_cursor.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/notification.dart';

/// 通知已读游标业务逻辑 (对标 PC business/notification/read-cursor.ts)
class NotificationReadCursorBusiness {
  final _readCursorService = getIt<NotificationReadCursorService>();

  Future<void> handleTableUpdates(
    int version,
    String userId,
    String category,
  ) async {
    await syncReadCursors(userId, [category]);
  }

  Future<void> syncReadCursors(String userId, List<String> categories) async {
    if (userId.isEmpty) return;

    final res = await getNotificationReadCursorsApi(
      IGetNotificationReadCursorsReq(
        categories: categories.isEmpty ? null : categories,
      ),
    );

    if (res.code != 0 || res.result == null || res.result!.cursors.isEmpty) {
      return;
    }

    for (final cursor in res.result!.cursors) {
      await _readCursorService.upsert({
        'userId': userId,
        'category': cursor.category,
        'version': cursor.version,
        'lastReadAt': cursor.lastReadAt,
        'updatedAt': cursor.lastReadAt,
      });
    }

    getIt<NotificationInboxBusiness>().notifyInboxUpdate();
  }
}
