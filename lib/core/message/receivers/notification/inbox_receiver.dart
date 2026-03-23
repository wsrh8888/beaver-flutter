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
    final userId = body['userId'] as String?;
    if (updates == null || userId == null) return;

    for (final update in updates) {
      final table = update['table'] as String?;
      final data = update['data'] as List?;

      if (table == 'notification_inbox' && data != null) {
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
}

final inboxReceiver = InboxReceiver();
