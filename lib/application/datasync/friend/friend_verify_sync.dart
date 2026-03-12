import 'package:beaver/shared/utils/storage_util.dart';

/// 好友验证同步 (对标 desktop datasync/friend/friend-verify.ts)
class FriendVerifySyncModule {
  Future<void> checkAndSync() async {
    if (StorageUtil.getString('userId') == null) return;
    await Future.delayed(const Duration(milliseconds: 10));
  }
}
