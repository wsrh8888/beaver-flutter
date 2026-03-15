import 'package:beaver/core/datasync/chat/chat.dart';
import 'package:beaver/core/datasync/friend/friend.dart';
import 'package:beaver/core/datasync/group/group.dart';
import 'package:beaver/core/datasync/user/user.dart';
import 'package:beaver/core/datasync/emoji/emoji.dart';
import 'package:beaver/core/datasync/notification/notification.dart';

/// 数据同步状态
enum DataSyncStatus {
  idle,
  syncing,
  ready,
  syncError,
}

/// 数据同步管理器
///
/// 职责：协调全局数据同步
/// - 管理同步状态
/// - 按顺序执行各模块同步
/// - 处理同步错误
class SyncManager {
  DataSyncStatus _status = DataSyncStatus.idle;
  DataSyncStatus get status => _status;
  bool get isSyncing => _status == DataSyncStatus.syncing;

  /// 自动开始全量同步流程
  Future<void> autoSync() async {
    print('[SyncManager] 开始全模块自动同步');
    _status = DataSyncStatus.syncing;
    try {
      // 1. 同步用户资料
      await userSync.checkAndSync();
      // 2. 同步聊天及会话 (含消息摘要、会话元数据、用户会话设置)
      await messageSync.checkAndSync();
      // 3. 同步好友关系 (含好友资料、好友验证)
      await friendSync.checkAndSync();
      // 4. 同步群组资料 (含群资料、群成员、入群申请)
      await groupSync.checkAndSync();
      // 5. 同步表情列表
      await emojiSync.checkAndSync();
      // 6. 同步通知事件
      await notificationSync.checkAndSync();

      _status = DataSyncStatus.ready;
      print('[SyncManager] 全模块数据同步完成，系统就绪');
    } catch (e) {
      _status = DataSyncStatus.idle;
      print('[SyncManager] 同步发生错误: $e');
    }
  }
}

final syncManager = SyncManager();