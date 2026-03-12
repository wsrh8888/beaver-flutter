import 'package:beaver/shared/utils/storage_util.dart';

/// 群资料同步 (对标 desktop datasync/group/group.ts)
class GroupSyncModule {
  Future<void> checkAndSync() async {
    if (StorageUtil.getString('userId') == null) return;
    await Future.delayed(const Duration(milliseconds: 10));
  }
}
