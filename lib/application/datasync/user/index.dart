import 'user_sync.dart';

final userSyncModule = UserSyncModule();

class UserDatasync {
  Future<void> checkAndSync() async {
    await userSyncModule.checkAndSync();
  }
}

final userDatasync = UserDatasync();
