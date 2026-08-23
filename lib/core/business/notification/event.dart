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
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/notification/event.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/notification.dart';
import 'package:drift/drift.dart';

/// 通知事件业务逻辑 (对标 PC business/notification/event.ts)
class NotificationEventBusiness {
  final _eventService = getIt<NotificationEventService>();

  Future<void> handleTableUpdates(String eventId) async {
    await syncEventsByIds([eventId]);
  }

  Future<void> syncEventsByIds(List<String> eventIds) async {
    if (eventIds.isEmpty) return;

    const batchSize = 50;
    for (var i = 0; i < eventIds.length; i += batchSize) {
      final batchIds = eventIds.sublist(
        i,
        i + batchSize > eventIds.length ? eventIds.length : i + batchSize,
      );

      final res = await getNotificationEventsByIdsApi(
        IGetNotificationEventsByIdsReq(eventIds: batchIds),
      );
      if (res.code != 0 || res.result == null || res.result!.events.isEmpty) {
        continue;
      }

      final companions = res.result!.events
          .map(
            (event) => NotificationEventsCompanion(
              eventId: Value(event.eventId),
              eventType: Value(event.eventType),
              category: Value(event.category),
              version: Value(event.version),
              fromUserId: Value(event.fromUserId),
              targetId: Value(event.targetId),
              targetType: Value(event.targetType),
              payload: Value(event.payload),
              priority: Value(event.priority),
              status: Value(event.status),
              dedupHash: Value(event.dedupHash),
              createdAt: Value(event.createdAt),
              updatedAt: Value(event.updatedAt),
            ),
          )
          .toList();

      await _eventService.batchCreate(companions);
    }
  }
}
