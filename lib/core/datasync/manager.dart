import 'package:beaver/core/datasync/index.dart';

/// 数据同步管理器
/// 
/// 职责：协调全局数据同步
/// - 管理同步状态
/// - 按顺序执行各模块同步
/// - 处理同步错误
class DataSyncManager {
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  /// 获取当前同步状态
  String getStatus() {
    return _isSyncing ? 'syncing' : 'idle';
  }

  /// 自动开始全量同步流程
  Future<void> autoSync() async {
    print('[DataSyncManager] 开始自动同步');
    
    try {
      _isSyncing = true;
      // TODO: 发送状态变更通知

      // 1. 同步用户资料
      await userDatasync.checkAndSync();
      // 2. 聊天相关同步 (含消息、会话元数据、用户会话设置)
      await chatDatasync.checkAndSync();
      // 3. 好友关系同步 (含好友资料、好友验证)
      await friendDatasync.checkAndSync();
      // 4. 群组资料同步 (含群资料、群成员、入群申请)
      await groupDatasync.checkAndSync();
      // 5. 表情同步
      await emojiSync.checkAndSync();
      // 6. 通知事件同步
      await notificationSync.checkAndSync();

      _isSyncing = false;
      // TODO: 发送状态变更通知 (ready)
      print('[DataSyncManager] 数据同步完成');
    } catch (e) {
      _isSyncing = false;
      // TODO: 发送状态变更通知 (sync_error)
      print('[DataSyncManager] 数据同步失败: $e');
    }
  }
}

final syncManager = DataSyncManager();