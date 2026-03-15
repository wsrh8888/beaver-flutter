import 'package:beaver/api/group.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/types/api/datasync.dart';

/// 入群申请同步
class GroupJoinRequestSync {
  Future<void> checkAndSync() async {
    print('[GroupJoinRequestSync] 开始同步入群申请');

    final datasyncService = getIt<DatasyncService>();
    final requestService = getIt<GroupJoinRequestService>();
    final groupService = getIt<GroupService>();

    // 1. 获取本地同步游标
    final cursor = await datasyncService.get('group_join_requests');
    final lastSyncTime = cursor?.version ?? 0;

    // 2. 获取摘要
    final response = await datasyncGetSyncGroupRequestsApi(IGetSyncGroupRequestsReq(since: lastSyncTime));
    if (response.code != 0 || response.result == null) {
      print('[GroupJoinRequestSync] 获取摘要失败: ${response.msg}');
      return;
    }

    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比并同步
    final needUpdate = await _compareAndFilterVersions(groupService, response.result!.groupVersions);

    if (needUpdate.isNotEmpty) {
      await _syncGroupRequests(requestService, groupService, needUpdate);
    }

    // 4. 更新游标
    await datasyncService.upsert('group_join_requests', -1, serverTimestamp);
    
    print('[GroupJoinRequestSync] 入群申请同步完成');
  }

  Future<List<IGroupRequestsVersionItem>> _compareAndFilterVersions(
    GroupService groupService,
    List<IGroupRequestsVersionItem> serverVersions,
  ) async {
    if (serverVersions.isEmpty) return [];

    final groupIds = serverVersions.map((e) => e.groupId).toList();
    final localVersions = await groupService.getModuleVersions('requests', groupIds);
    final localMap = {for (var v in localVersions) v.groupId: v.version};

    return serverVersions.where((sv) => (localMap[sv.groupId] ?? 0) < sv.version).toList();
  }

  Future<void> _syncGroupRequests(
    GroupJoinRequestService requestService,
    GroupService groupService,
    List<IGroupRequestsVersionItem> needUpdate,
  ) async {
    for (final item in needUpdate) {
      final groupVersion = IGroupVersionSyncItem(groupId: item.groupId, version: item.version);
      final response = await groupJoinRequestSyncApi(IGroupJoinRequestSyncReq(groups: [groupVersion]));
      if (response.code == 0 && response.result != null) {
        await requestService.batchCreate(response.result!.groupJoinRequests);
        await groupService.upsertSyncStatus(module: 'requests', groupId: item.groupId, version: item.version);
      }
    }
  }
}

final groupJoinRequestSync = GroupJoinRequestSync();
