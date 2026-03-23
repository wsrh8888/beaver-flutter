import 'package:beaver/api/notification.dart';
import 'package:beaver/types/api/notification.dart';
import 'package:beaver/core/database/services/notification/read_cursor.dart';
import 'package:beaver/di/injection.dart';

/// 通知已读游标业务逻辑 (对标 PC business/notification/read-cursor.ts)
class NotificationReadCursorBusiness {
  final _readCursorService = getIt<NotificationReadCursorService>();

  /**
   * 按版本同步通知已读游标
   */
  Future<void> handleTableUpdates(int version, String userId, String category) async {
    print('[NotificationReadCursorBusiness] 处理已读游标同步: userId=$userId, category=$category, version=$version');
    try {
      final res = await getNotificationReadCursorsApi(
        IGetNotificationReadCursorsReq(categories: []), // 同步所有分类
      );

      if (res.code == 0 && res.result != null && res.result!.cursors.isNotEmpty) {
        for (final cursor in res.result!.cursors) {
          await _readCursorService.upsert({
            'userId': userId,
            'category': cursor.category.toString(),
            'version': cursor.version,
            'lastReadAt': cursor.lastReadVersion,
            'updatedAt': cursor.updatedAt,
          });
        }
        print('[NotificationReadCursorBusiness] 已读游标同步完成: userId=$userId');
      }
    } catch (e) {
      print('[NotificationReadCursorBusiness] handleTableUpdates 失败: $e');
    }
  }
}
