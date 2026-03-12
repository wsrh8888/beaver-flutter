import 'group_join_request_sync.dart';
import 'group_member_sync.dart';
import 'group_sync.dart';

final groupSyncModule = GroupSyncModule();
final groupMemberSync = GroupMemberSync();
final groupJoinRequestSync = GroupJoinRequestSync();

class GroupDatasync {
  Future<void> checkAndSync() async {
    await Future.wait([
      groupSyncModule.checkAndSync(),
      groupMemberSync.checkAndSync(),
      groupJoinRequestSync.checkAndSync(),
    ]);
  }
}

final groupDatasync = GroupDatasync();
