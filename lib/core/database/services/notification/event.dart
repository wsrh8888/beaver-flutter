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

import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class NotificationEventService extends BaseService {
  const NotificationEventService();

  /// 批量创建通知事件
  Future<void> batchCreate(List<NotificationEventsCompanion> events) async {
    if (events.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final event in events) {
        batch.insert(
          db.notificationEvents,
          event,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 按版本增量拉取事件
  Future<List<NotificationEvent>> getEventsAfterVersion(int version, {int limit = 100}) async {
    return (db.select(db.notificationEvents)
          ..where((t) => t.version.isBiggerThanValue(version))
          ..orderBy([(t) => OrderingTerm(expression: t.version)])
          ..limit(limit))
        .get();
  }

  /// 获取指定事件ID的本地版本映射
  Future<Map<String, int>> getVersionMapByIds(List<String> eventIds) async {
    if (eventIds.isEmpty) {
      return {};
    }

    final rows = await (db.select(db.notificationEvents)..where((t) => t.eventId.isIn(eventIds))).get();

    final versionMap = <String, int>{};
    for (final row in rows) {
      versionMap[row.eventId] = row.version ?? 0;
    }

    return versionMap;
  }

  /// 根据事件ID列表获取事件明细
  Future<List<NotificationEvent>> getByIds(List<String> eventIds) async {
    if (eventIds.isEmpty) {
      return [];
    }

    return (db.select(db.notificationEvents)..where((t) => t.eventId.isIn(eventIds))).get();
  }
}
