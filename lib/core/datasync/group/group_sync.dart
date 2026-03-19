import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/group.dart';
import 'package:drift/drift.dart';

/// 群资料同步器（对应服务器 group 表）
class GroupSync {
  /// 检查并同步群资料
  Future<void> checkAndSync() async {
    print('[GroupSync] 开始同步群资料数据');
    try {
      final datasyncService = getIt<DatasyncService>();
      final groupService = getIt<GroupService>();
      final syncStatusService = getIt<GroupSyncStatusService>();

      // 获取本地最后同步时间
      final cursor = await datasyncService.get('groups');
      final lastSyncTime = cursor?.version ?? 0;

      // 获取服务器上变更的群组版本信息
      final response = await datasyncGetSyncGroupInfoApi(IGetSyncGroupInfoReq(since: lastSyncTime));
      if (response.code != 0 || response.result == null) {
        print('[GroupSync] 获取群组版本失败: ${response.msg}');
        return;
      }

      // 对比本地数据，过滤出需要更新的群组
      final needUpdateGroups = await _compareAndFilterGroupVersions(syncStatusService, response.result!.groupVersions);

      if (needUpdateGroups.isNotEmpty) {
        // 有需要更新的群资料
        await _syncGroupData(groupService, syncStatusService, needUpdateGroups);
      }

      // 更新游标（无论是否有变更都要更新）
      await datasyncService.upsert(
        'groups',
        -1, // 使用时间戳而不是版本号
        response.result!.serverTimestamp,
      );
    } catch (error) {
      print('[GroupSync] 群资料同步失败: $error');
    }
  }

  /// 对比本地数据，过滤出需要更新的群组信息
  Future<List<IGroupVersionSyncItem>> _compareAndFilterGroupVersions(
    GroupSyncStatusService syncStatusService,
    List<IGroupInfoVersionItem> groupVersions,
  ) async {
    if (groupVersions.isEmpty) return [];

    // 提取所有变更的群组ID
    final groupIds = groupVersions.map((item) => item.groupId).toList();

    // 查询本地已存在的群组资料版本状态
    final localVersions = await syncStatusService.getModuleVersions('info', groupIds);
    final localVersionMap = {for (var v in localVersions) (v['groupId'] as String): (v['version'] as int)};

    // 过滤出需要更新的群组，并使用本地版本号
    final List<IGroupVersionSyncItem> needUpdateGroups = [];
    for (var groupVersion in groupVersions) {
      final localVersion = localVersionMap[groupVersion.groupId] ?? 0;
      if (localVersion < groupVersion.version) {
        needUpdateGroups.add(IGroupVersionSyncItem(
          groupId: groupVersion.groupId,
          version: localVersion,
        ));
      }
    }

    return needUpdateGroups;
  }

  /// 同步群资料数据
  Future<void> _syncGroupData(
    GroupService groupService,
    GroupSyncStatusService syncStatusService,
    List<IGroupVersionSyncItem> groupsWithVersions,
  ) async {
    if (groupsWithVersions.isEmpty) return;

    // 直接使用传入的群组版本信息构造请求
    final response = await groupSyncApi(IGroupSyncReq(groups: groupsWithVersions));
    if (response.code == 0 && response.result != null && response.result!.groups.isNotEmpty) {
      for (final group in response.result!.groups) {
        await groupService.upsert(GroupsCompanion(
          groupId: Value(group.groupId),
          title: Value(group.title),
          avatar: Value(group.avatar),
          creatorId: Value(group.creatorId),
          joinType: Value(group.joinType),
          status: Value(group.status),
          version: Value(group.version),
          createdAt: Value(group.createdAt),
          updatedAt: Value(group.updatedAt),
        ));

        // 更新本地群组版本状态
        await syncStatusService.upsertSyncStatus(
          module: 'info',
          groupId: group.groupId,
          version: group.version,
        );
      }

      // TODO: 发送通知到渲染进程
    }
  }
}

final groupSync = GroupSync();
