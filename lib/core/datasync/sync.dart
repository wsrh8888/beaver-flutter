import 'chat/chat.dart';
import 'friend/friend.dart';
import 'group/group.dart';
import 'user/user.dart';

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

  Future<void> autoSync() async {
    if (_status == DataSyncStatus.syncing) return;
    print('[SyncManager] 开始自动同步');
    _status = DataSyncStatus.syncing;
    try {
      await userSync.checkAndSync();
      await messageSync.checkAndSync();
      await friendSync.checkAndSync();
      await groupSync.checkAndSync();
      _status = DataSyncStatus.ready;
      print('[SyncManager] 数据同步完成，系统就绪');
    } catch (e) {
      _status = DataSyncStatus.syncError;
      print('[SyncManager] 同步失败: $e');
    }
  }
}

final syncManager = SyncManager();