import 'package:beaver/api/notification.dart';
import 'package:beaver/types/api/notification.dart';
import 'package:beaver/core/database/services/notification/inbox.dart';
import 'package:beaver/di/injection.dart';

/// 通知收件箱业务逻辑 (对标 PC business/notification/inbox.ts)
class NotificationInboxBusiness {
  final _inboxService = getIt<NotificationInboxService>();

  /**
   * 按版本同步通知收件箱
   */
  Future<void> handleTableUpdates(int version, String eventId, String userId) async {
    print('[NotificationInboxBusiness] 处理收件箱同步: userId=$userId, eventId=$eventId, version=$version');
    try {
      final res = await getNotificationInboxByIdsApi(
        IGetNotificationInboxByIdsReq(inboxIds: [eventId]),
      );

      if (res.code == 0 && res.result != null && res.result!.inboxes.isNotEmpty) {
        // 更新本地数据库
        final inboxRows = res.result!.inboxes.map((inbox) => {
          'userId': userId,
          'eventId': inbox.eventId,
          'eventType': '', // 默认值
          'category': '', // 默认值
          'version': inbox.version,
          'isRead': inbox.readStatus,
          'readAt': 0, // 默认值
          'status': 1, // 默认值
          'isDeleted': 0, // 默认值
          'silent': 0, // 默认值
          'createdAt': inbox.createdAt,
          'updatedAt': inbox.updatedAt ?? 0,
        }).toList();

        await _inboxService.batchCreate({'inboxes': inboxRows});
        print('[NotificationInboxBusiness] 收件箱同步成功: eventId=$eventId');
      }
    } catch (e) {
      print('[NotificationInboxBusiness] handleTableUpdates 失败: $e');
    }
  }
}
