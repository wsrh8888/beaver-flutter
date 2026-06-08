import 'dart:async';

import 'package:beaver/api/notification.dart';
import 'package:beaver/core/database/services/notification/inbox.dart';
import 'package:beaver/core/database/services/notification/read_cursor.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/notification.dart';

/// 通知收件箱业务逻辑 (对标 PC business/notification/inbox.ts)
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
    await syncInboxesByEventIds(userId, [eventId]);
  }

  Future<void> syncInboxesByEventIds(String userId, List<String> eventIds) async {
    if (eventIds.isEmpty || userId.isEmpty) return;

    const batchSize = 50;
    for (var i = 0; i < eventIds.length; i += batchSize) {
      final batchIds = eventIds.sublist(
        i,
        i + batchSize > eventIds.length ? eventIds.length : i + batchSize,
      );

      final res = await getNotificationInboxByIdsApi(
        IGetNotificationInboxByIdsReq(eventIds: batchIds),
      );
      if (res.code != 0 || res.result == null || res.result!.inbox.isEmpty) {
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
  }

  Future<Map<String, dynamic>> getUnreadSummary(
    String userId, {
    List<String>? categories,
  }) async {
    final filterCategories = categories ?? ['social', 'group', 'system'];
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

    return {'total': total, 'byCat': byCat};
  }
}
