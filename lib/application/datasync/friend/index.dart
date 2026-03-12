import 'friend_sync.dart';
import 'friend_verify_sync.dart';

final friendSyncModule = FriendSyncModule();
final friendVerifySyncModule = FriendVerifySyncModule();

class FriendDatasync {
  Future<void> checkAndSync() async {
    await Future.wait([
      friendSyncModule.checkAndSync(),
      friendVerifySyncModule.checkAndSync(),
    ]);
  }
}

final friendDatasync = FriendDatasync();
