import 'package:beaver/api/notification.dart';
import 'package:beaver/types/api/notification.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/notification/event.dart';
import 'package:beaver/di/injection.dart';
import 'package:drift/drift.dart';

/// 通知事件业务逻辑 (对标 PC business/notification/event.ts)
class NotificationEventBusiness {
  final _eventService = getIt<NotificationEventService>();

  /**
   * 处理通知事件更新
   */
  Future<void> handleTableUpdates(String eventId) async {
    print('[NotificationEventBusiness] 处理事件同步: $eventId');
    try {
      final res = await getNotificationEventsByIdsApi(
        IGetNotificationEventsByIdsReq(eventIds: [eventId]),
      );

      if (res.code == 0 && res.result != null && res.result!.events.isNotEmpty) {
        final companions = res.result!.events.map((e) => NotificationEventsCompanion(
          eventId: Value(e.eventId),
          eventType: Value(e.type.toString()),
          targetType: const Value(''), // 默认值
          payload: Value(e.content),
          version: Value(e.version),
          status: Value(e.status),
          createdAt: Value(e.createdAt),
          updatedAt: Value(e.updatedAt),
        )).toList();
        
        await _eventService.batchCreate(companions);
        print('[NotificationEventBusiness] 事件同步成功: $eventId');
      }
    } catch (e) {
      print('[NotificationEventBusiness] handleTableUpdates 失败: $e');
    }
  }
}
