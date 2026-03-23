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
