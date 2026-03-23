import 'dart:async';
import 'package:beaver/api/notification.dart';
import 'package:beaver/types/api/notification.dart';
import 'package:beaver/core/database/services/notification/inbox.dart';
import 'package:beaver/core/database/services/notification/read_cursor.dart';
import 'package:beaver/di/injection.dart';

/// 通知收件箱业务逻辑 (对标 PC business/notification/inbox.ts)
class NotificationInboxBusiness {
  final _inboxService = getIt<NotificationInboxService>();
  final _updateController = StreamController<void>.broadcast();

  Stream<void> get inboxUpdateStream => _updateController.stream;

  /**
   * 处理通知收件箱更新通知
   */
  Future<void> handleTableUpdates(
    int version,
    String eventId,
    String userId,
  ) async {
    print(
      '[NotificationInboxBusiness] 处理收件箱同步: userId=$userId, eventId=$eventId, version=$version',
    );
    try {
      final res = await getNotificationInboxByIdsApi(
        IGetNotificationInboxByIdsReq(inboxIds: [eventId]),
      );

      if (res.code == 0 &&
          res.result != null &&
          res.result!.inboxes.isNotEmpty) {
        // 更新本地数据库
        final inboxRows = res.result!.inboxes
            .map(
              (inbox) => {
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
              },
            )
            .toList();

        await _inboxService.batchCreate({'inboxes': inboxRows});
        _updateController.add(null); // 通知更新
        print('[NotificationInboxBusiness] 收件箱同步成功: eventId=$eventId');
      }
    } catch (e) {
      print('[NotificationInboxBusiness] handleTableUpdates 失败: $e');
    }
  }

  /**
   * 获取未读通知汇总
   */
  Future<Map<String, dynamic>> getUnreadSummary(
    String userId, {
    List<String>? categories,
  }) async {
    final filterCategories = categories ?? ['social', 'group', 'system'];
    final Map<String, int> byCat = {};
    int total = 0;

    for (final category in filterCategories) {
      // 获取已读游标
      final cursorService = getIt<NotificationReadCursorService>();
      final cursor = await cursorService.getReadCursor({
        'userId': userId,
        'category': category,
      });
      final lastReadAt = cursor?['lastReadAt'] as int? ?? 0;

      // 获取该时间点后的未读数
      // 注意: 这里需要 service 支持 getUnreadCountAfterTime
      // 暂时用 getInboxByUserId 模拟过滤，稍后优化 Service
      final inboxes = await _inboxService.getInboxByUserIdAndCategory({
        'userId': userId,
        'category': category,
      });

      final unreadCount = inboxes
          .where(
            (item) =>
                (item['createdAt'] as int) > lastReadAt && item['isRead'] == 0,
          )
          .length;

      byCat[category] = unreadCount;
      total += unreadCount;
    }

    return {'total': total, 'byCat': byCat};
  }
}
