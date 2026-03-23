import 'package:beaver/core/datasync/friend/friend_sync.dart';
import 'package:beaver/core/datasync/friend/friend_verify_sync.dart';

/// 好友数据同步统一入口
class FriendDatasync {
  Future<void> checkAndSync() async {
    // 并行同步好友数据和好友验证数据
    await Future.wait([
      friendSyncModule.checkAndSync(),
      friendVerifySyncModule.checkAndSync(),
    ]);
  }
}

final friendDatasync = FriendDatasync();