import 'package:beaver/api/notification.dart';
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
  }
}
