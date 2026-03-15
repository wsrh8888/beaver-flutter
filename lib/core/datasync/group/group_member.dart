import 'package:beaver/api/group.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/types/api/datasync.dart';

/// 群成员同步
class GroupMemberSync {
  Future<void> checkAndSync() async {
    print('[GroupMemberSync] 开始同步群成员');

    final datasyncService = getIt<DatasyncService>();
    final groupService = getIt<GroupService>();
    final memberService = getIt<GroupMemberService>();

    // 1. 获取本地同步游标
    final cursor = await datasyncService.get('group_members');
    final lastSyncTime = cursor?.version ?? 0;

    // 2. 获取摘要
    final response = await datasyncGetSyncGroupMembersApi(IGetSyncGroupMembersReq(since: lastSyncTime));
    if (response.code != 0 || response.result == null) {
      print('[GroupMemberSync] 获取群成员摘要失败: ${response.msg}');
      return;
    }

    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比并同步
    final needUpdate = await _compareAndFilterVersions(groupService, response.result!.groupVersions);

    if (needUpdate.isNotEmpty) {
      await _syncGroupMembers(memberService, groupService, needUpdate);
    }

    // 4. 更新游标
    await datasyncService.upsert('group_members', -1, serverTimestamp);
    
    print('[GroupMemberSync] 群成员同步完成');
  }

  Future<List<IGroupMembersVersionItem>> _compareAndFilterVersions(
    GroupService groupService,
    List<IGroupMembersVersionItem> serverVersions,
  ) async {
    if (serverVersions.isEmpty) return [];

    final groupIds = serverVersions.map((e) => e.groupId).toList();
    final localVersions = await groupService.getModuleVersions('members', groupIds);
    final localMap = {for (var v in localVersions) v.groupId: v.version};

    return serverVersions.where((sv) => (localMap[sv.groupId] ?? 0) < sv.version).toList();
  }

  Future<void> _syncGroupMembers(
    GroupMemberService memberService,
    GroupService groupService,
    List<IGroupMembersVersionItem> needUpdate,
  ) async {
    for (final item in needUpdate) {
      // Create IGroupVersionSyncItem for the request
      final groupVersion = IGroupVersionSyncItem(groupId: item.groupId, version: item.version);
      final response = await groupMemberSyncApi(IGroupMemberSyncReq(groups: [groupVersion]));
      if (response.code == 0 && response.result != null) {
        await memberService.batchCreate(response.result!.groupMembers);
        await groupService.upsertSyncStatus(module: 'members', groupId: item.groupId, version: item.version);
      }
    }
  }
}

final groupMemberSync = GroupMemberSync();
