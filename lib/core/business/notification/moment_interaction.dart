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

import 'dart:convert';

import 'package:beaver/core/database/services/notification/event.dart';
import 'package:beaver/core/database/services/notification/inbox.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/moment_interaction.dart';

/// 朋友圈互动消息（对标微信「朋友圈消息」）
class MomentInteractionBusiness {
  final _inboxService = getIt<NotificationInboxService>();
  final _eventService = getIt<NotificationEventService>();

  Future<List<MomentInteractionItem>> getInteractions(String userId) async {
    if (userId.isEmpty) return [];

    final inboxRows = await _inboxService.getInboxByUserIdAndCategory({
      'userId': userId,
      'category': 'moment',
    });

    final activeRows = inboxRows
        .where((row) => (row['isDeleted'] as int? ?? 0) == 0)
        .toList();
    if (activeRows.isEmpty) return [];

    final eventIds = activeRows
        .map((row) => row['eventId'] as String? ?? '')
        .where((id) => id.isNotEmpty)
        .toList();
    final events = await _eventService.getByIds(eventIds);
    final eventMap = {for (final event in events) event.eventId: event};

    final items = <MomentInteractionItem>[];
    for (final row in activeRows) {
      final eventId = row['eventId'] as String? ?? '';
      final event = eventMap[eventId];
      if (event == null) continue;

      if (event.eventType == 'moment_unlike') continue;

      final payload = _parsePayload(event.payload);
      final momentId = payload['momentId'] as String? ??
          event.targetId ??
          '';
      if (momentId.isEmpty) continue;

      items.add(
        MomentInteractionItem(
          eventId: eventId,
          eventType: event.eventType,
          fromUserId: event.fromUserId ?? '',
          momentId: momentId,
          commentId: payload['commentId'] as String?,
          content: payload['content'] as String?,
          createdAt: row['createdAt'] as int? ??
              event.createdAt ??
              0,
          isRead: (row['isRead'] as int? ?? 0) == 1,
        ),
      );
    }

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Map<String, dynamic> _parsePayload(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return {};
  }
}
