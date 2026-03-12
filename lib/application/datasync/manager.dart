import 'chat/index.dart';
import 'friend/index.dart';
import 'group/index.dart';
import 'user/index.dart';

/// 数据同步状态 (对标 desktop 通知前端的 status)
enum DataSyncStatus {
  idle,
  syncing,
  ready,
  syncError,
}

/// 数据同步管理器 (对标 desktop main/datasync/manager.ts)
class DataSyncManager {
  DataSyncStatus _status = DataSyncStatus.idle;
  DataSyncStatus get status => _status;
  bool get isSyncing => _status == DataSyncStatus.syncing;

  Future<void> autoSync() async {
    if (_status == DataSyncStatus.syncing) return;
    print('[DataSync] 开始自动同步');
    _status = DataSyncStatus.syncing;
    try {
      await userDatasync.checkAndSync();
      await chatDatasync.checkAndSync();
      await friendDatasync.checkAndSync();
      await groupDatasync.checkAndSync();
      _status = DataSyncStatus.ready;
      print('[DataSync] 数据同步完成，系统就绪');
    } catch (e) {
      _status = DataSyncStatus.syncError;
      print('[DataSync] 同步失败: $e');
    }
  }
}

final dataSyncManager = DataSyncManager();
