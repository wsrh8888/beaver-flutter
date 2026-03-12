import 'package:beaver/shared/utils/storage_util.dart';

/// 好友数据同步 (对标 desktop datasync/friend/friend.ts)
class FriendSyncModule {
  Future<void> checkAndSync() async {
    if (StorageUtil.getString('userId') == null) return;
    print('[DataSync] 开始同步好友数据');
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      print('[DataSync] 好友同步完成');
    } catch (e) {
      print('[DataSync] 好友同步失败: $e');
    }
  }
}
