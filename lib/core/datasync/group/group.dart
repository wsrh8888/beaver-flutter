import 'package:drift/drift.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/group.dart' as group_types;

import 'package:beaver/core/datasync/group/group_member.dart';
import 'package:beaver/core/datasync/group/group_request.dart';

/// 群组同步
class GroupSync {
  Future<void> checkAndSync() async {
    // 1. 同步群组资料
    await _syncGroups();
    // 2. 同步群成员
    await groupMemberSync.checkAndSync();
    // 3. 同步入群申请
    await groupJoinRequestSync.checkAndSync();
  }

  Future<void> _syncGroups() async {
    print('[GroupSync] 开始同步群组数据');

    final datasyncService = getIt<DatasyncService>();
    final groupService = getIt<GroupService>();

    // 1. 获取本地同步游标
    final cursor = await datasyncService.get('groups');
    final lastSyncTime = cursor?.version ?? 0;

    // 2. 获取变更的群组版本摘要
    final response = await datasyncGetSyncGroupInfoApi(IGetSyncGroupInfoReq(since: lastSyncTime));
    
    if (response.code != 0 || response.result == null) {
      print('[GroupSync] 获取群组版本失败: ${response.msg}');
      return;
    }

    final groupVersions = response.result!.groupVersions;
    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比本地数据，过滤出需要更新的群组
    final needUpdateGroups = await _compareAndFilterGroupVersions(groupService, groupVersions);

    if (needUpdateGroups.isNotEmpty) {
      // 4. 同步具体群组数据
      await _syncGroupData(groupService, needUpdateGroups);
      
      // 5. 更新游标
      final maxVersion = groupVersions.map((e) => e.version).reduce((a, b) => a > b ? a : b);
      await datasyncService.upsert('groups', maxVersion, serverTimestamp);
    } else {
      // 没有更新
      await datasyncService.upsert('groups', null, serverTimestamp);
    }

    print('[GroupSync] 群组同步完成');
  }

  Future<List<group_types.IGroupVersionSyncItem>> _compareAndFilterGroupVersions(
    GroupService groupService,
    List<IGroupInfoVersionItem> serverVersions,
  ) async {
    if (serverVersions.isEmpty) return [];

    final localStatuses = await groupService.getAllGroupSyncStatus('group_info');
    final localVersionMap = {for (var s in localStatuses) s.groupId: s.version};

    final List<group_types.IGroupVersionSyncItem> needUpdate = [];
    for (final sv in serverVersions) {
      final localVersion = localVersionMap[sv.groupId] ?? 0;
      if (localVersion < sv.version) {
        needUpdate.add(group_types.IGroupVersionSyncItem(groupId: sv.groupId, version: localVersion));
      }
    }
    return needUpdate;
  }

  Future<void> _syncGroupData(GroupService groupService, List<group_types.IGroupVersionSyncItem> groupsWithVersions) async {
    if (groupsWithVersions.isEmpty) return;

    final response = await groupSyncApi(group_types.IGroupSyncReq(groups: groupsWithVersions));
    if (response.code == 0 && response.result != null) {
      final groups = response.result!.groups;
      await groupService.batchCreate(groups);

      // 更新同步状态表
      final statusUpdates = groups.map((g) => GroupSyncStatusCompanion(
        groupId: Value(g.groupId),
        module: const Value('group_info'),
        version: Value(g.version),
      )).toList();
      await groupService.batchUpsertGroupSyncStatus(statusUpdates);
      
      // TODO: 发送通知通知 UI
    }
  }
}

final groupSync = GroupSync();