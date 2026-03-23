import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/group.dart';

/// 入群申请同步器
class GroupJoinRequestSync {
  /// 检查并同步入群申请数据
  Future<void> checkAndSync() async {
    try {
      final datasyncService = getIt<DatasyncService>();
      final groupJoinRequestService = getIt<GroupJoinRequestService>();
      final syncStatusService = getIt<GroupSyncStatusService>();

      // 获取本地最后同步时间
      final cursor = await datasyncService.get('group_join_requests');
      final lastSyncTime = cursor?.version ?? 0;

      // 获取服务器上变更的版本信息
      final response = await datasyncGetSyncGroupRequestsApi(
        IGetSyncGroupRequestsReq(since: lastSyncTime),
      );
      if (response.code != 0 || response.result == null) {
        // print('[GroupJoinRequestSync] 获取摘要获取失败: ${response.msg}');
        return;
      }

      // 对比过滤
      final needUpdateGroups = await _compareAndFilterRequestVersions(
        syncStatusService,
        response.result!.groupVersions,
      );

      if (needUpdateGroups.isNotEmpty) {
        // 同步具体数据
        await _syncRequestData(
          groupJoinRequestService,
          syncStatusService,
          needUpdateGroups,
        );
      }

      // 更新游标
      await datasyncService.upsert(
        'group_join_requests',
        -1,
        response.result!.serverTimestamp,
      );
    } catch (error) {
      // print('[GroupJoinRequestSync] 同步失败: $error');
    }
  }

  /// 对比过滤版本
  Future<List<IGroupVersionSyncItem>> _compareAndFilterRequestVersions(
    GroupSyncStatusService syncStatusService,
    List<IGroupRequestsVersionItem> groupVersions,
  ) async {
    if (groupVersions.isEmpty) return [];

    final groupIds = groupVersions.map((item) => item.groupId).toList();
    final localVersions = await syncStatusService.getModuleVersions(
      'requests',
      groupIds,
    );
    final localVersionMap = {
      for (var v in localVersions)
        (v['groupId'] as String): (v['version'] as int),
    };

    final List<IGroupVersionSyncItem> needUpdateGroups = [];
    for (var groupVersion in groupVersions) {
      final localVersion = localVersionMap[groupVersion.groupId] ?? 0;
      if (localVersion < groupVersion.version) {
        needUpdateGroups.add(
          IGroupVersionSyncItem(
            groupId: groupVersion.groupId,
            version: localVersion,
          ),
        );
      }
    }

    return needUpdateGroups;
  }

  /// 同步入群申请
  Future<void> _syncRequestData(
    GroupJoinRequestService groupJoinRequestService,
    GroupSyncStatusService syncStatusService,
    List<IGroupVersionSyncItem> groupsWithVersions,
  ) async {
    if (groupsWithVersions.isEmpty) return;

    final response = await groupJoinRequestSyncApi(
      IGroupJoinRequestSyncReq(groups: groupsWithVersions),
    );
    if (response.code == 0 &&
        response.result != null &&
        response.result!.groupJoinRequests.isNotEmpty) {
      await groupJoinRequestService.batchCreate(
        response.result!.groupJoinRequests,
      );

      for (final req in response.result!.groupJoinRequests) {
        await syncStatusService.upsertSyncStatus(
          module: 'requests',
          groupId: req.groupId,
          version: req.version,
        );
      }
    }
  }
}

final groupJoinRequestSync = GroupJoinRequestSync();
