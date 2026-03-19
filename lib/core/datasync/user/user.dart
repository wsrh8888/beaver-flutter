import 'package:beaver/core/datasync/user/user_sync.dart';

/// 用户数据同步统一入口
class UserDatasync {
  Future<void> checkAndSync() async {
    // 同步用户资料
    await userSyncModule.checkAndSync();
  }
}

final userDatasync = UserDatasync();