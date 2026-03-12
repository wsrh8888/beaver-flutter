import 'package:beaver/shared/utils/storage_util.dart';

/// 入群申请同步 (对标 desktop datasync/group/group-join-request.ts)
class GroupJoinRequestSync {
  Future<void> checkAndSync() async {
    if (StorageUtil.getString('userId') == null) return;
    await Future.delayed(const Duration(milliseconds: 10));
  }
}
