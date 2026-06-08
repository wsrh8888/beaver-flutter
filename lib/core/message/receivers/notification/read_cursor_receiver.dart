import 'package:beaver/core/business/notification/read_cursor.dart';
import 'package:beaver/di/injection.dart';

/// 通知已读游标接收器 - 处理 notification_read_cursor 表的操作 (对标 PC receivers/notification/read-cursor-receiver.ts)
class ReadCursorReceiver {
  NotificationReadCursorBusiness get _readCursorBusiness => getIt<NotificationReadCursorBusiness>();

  /**
   * 处理通知已读游标更新通知
   */
  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final updates = (body['tableUpdates'] ?? body['tables']) as List?;
    if (updates == null) return;

    for (final update in updates) {
      final table = update['table'] as String?;
      final data = update['data'] as List?;
      final userId = update['userId'] as String?;

      if (table != 'notification_read_cursor' || data == null || userId == null) {
        continue;
      }

      for (final item in data) {
        final version = item['version'] as int?;
        final category = item['category'] as String?;
        if (version != null && category != null) {
          await _readCursorBusiness.handleTableUpdates(version, userId, category);
        }
      }
    }
  }
}

final readCursorReceiver = ReadCursorReceiver();
