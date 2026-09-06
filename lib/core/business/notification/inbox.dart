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

import 'dart:async';

import 'package:beaver/api/notification.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/core/database/services/notification/inbox.dart';
import 'package:beaver/core/database/services/notification/read_cursor.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/notification.dart';

const notificationCategories = ['social', 'group', 'system', 'moment'];

/// 通知收件箱业务逻辑 (对标 PC business/notification/inbox.ts)
final _logger = Logger('business-notification-inbox');

class NotificationInboxBusiness {
  final _inboxService = getIt<NotificationInboxService>();
  final _updateController = StreamController<void>.broadcast();

  Stream<void> get inboxUpdateStream => _updateController.stream;

  void notifyInboxUpdate() {
    _updateController.add(null);
  }

  Future<void> handleTableUpdates(
    int version,
    String eventId,
    String userId,
  ) async {
    _logger.info({'text': '收到通知收件箱表更新', 'data': {'eventId': eventId, 'userId': userId}});
    await syncInboxesByEventIds(userId, [eventId]);
  }

  Future<void> syncInboxesByEventIds(String userId, List<String> eventIds) async {
    _logger.info({'text': '开始按事件ID同步通知收件箱', 'data': {'userId': userId, 'count': eventIds.length}});
    if (eventIds.isEmpty || userId.isEmpty) return;

    const batchSize = 50;
    try {
      for (var i = 0; i < eventIds.length; i += batchSize) {
        final batchIds = eventIds.sublist(
          i,
          i + batchSize > eventIds.length ? eventIds.length : i + batchSize,
        );

        final res = await getNotificationInboxByIdsApi(
          IGetNotificationInboxByIdsReq(eventIds: batchIds),
        );
        if (res.code != 0 || res.result == null || res.result!.inbox.isEmpty) {
          _logger.warn({
            'text': '获取通知收件箱失败',
            'data': {'code': res.code, 'msg': res.msg, 'batchCount': batchIds.length},
          });
          continue;
        }

        final inboxRows = res.result!.inbox
            .map(
              (inbox) => {
                'userId': userId,
                'eventId': inbox.eventId,
                'eventType': inbox.eventType,
                'category': inbox.category,
                'version': inbox.version,
                'isRead': inbox.isRead ? 1 : 0,
                'readAt': inbox.readAt,
                'status': inbox.status,
                'isDeleted': inbox.isDeleted ? 1 : 0,
                'silent': inbox.silent ? 1 : 0,
                'createdAt': inbox.createdAt,
                'updatedAt': inbox.updatedAt,
              },
            )
            .toList();

        await _inboxService.batchCreate({'inboxes': inboxRows});
      }

      notifyInboxUpdate();
    } catch (e) {
      _logger.warn({'text': '按事件ID同步通知收件箱异常', 'data': {'userId': userId, 'error': e.toString()}});
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUnreadSummary(
    String userId, {
    List<String>? categories,
  }) async {
    _logger.info({'text': '获取未读通知汇总', 'data': {'userId': userId}});
    try {
      final filterCategories = categories ?? notificationCategories;
      final Map<String, int> byCat = {};
      int total = 0;

      for (final category in filterCategories) {
        final cursorService = getIt<NotificationReadCursorService>();
        final cursor = await cursorService.getReadCursor({
          'userId': userId,
          'category': category,
        });
        final lastReadAt = cursor?['lastReadAt'] as int? ?? 0;

        final unreadCount = await _inboxService.getUnreadCountAfterTime(
          userId: userId,
          category: category,
          afterTime: lastReadAt,
        );

        byCat[category] = unreadCount;
        total += unreadCount;
      }

      _logger.info({'text': '未读通知汇总完成', 'data': {'total': total}});
      return {'total': total, 'byCat': byCat};
    } catch (e) {
      _logger.warn({'text': '获取未读通知汇总失败', 'data': {'userId': userId, 'error': e.toString()}});
      rethrow;
    }
  }
}
