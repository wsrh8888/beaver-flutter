import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';

/// 通知事件同步
class NotificationSync {
  Future<void> checkAndSync() async {
    final datasyncService = getIt<DatasyncService>();

    // 1. 获取本地同步游标
    final cursor = await datasyncService.get('notification_events');
    final lastSyncTime = cursor?.version ?? 0;

    // 2. 获取摘要
    final response = await datasyncGetSyncNotificationEventsApi(
      IGetSyncNotificationEventsReq(sinceVersion: lastSyncTime),
    );

    if (response.code != 0 || response.result == null) {
      // print('[NotificationSync] 获取通知版本失败: ${response.msg}');
      return;
    }

    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 更新游标
    // TODO: 实现具体通知事件数据的拉取逻辑

    await datasyncService.upsert(
      'notification_events',
      response.result!.maxVersion,
      serverTimestamp,
    );
  }
}

final notificationSync = NotificationSync();
