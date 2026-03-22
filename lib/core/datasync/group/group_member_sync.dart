import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/group.dart';
import 'package:drift/drift.dart';

/// 群成员同步器
class GroupMemberSync {
  /// 检查并同步群成员
  Future<void> checkAndSync() async {
    print('[GroupMemberSync] 开始同步群成员数据');
    try {
      final datasyncService = getIt<DatasyncService>();
      final groupMemberService = getIt<GroupMemberService>();
      final syncStatusService = getIt<GroupSyncStatusService>();

      // 获取本地最后同步时间
      final cursor = await datasyncService.get('group_members');
      final lastSyncTime = cursor?.version ?? 0;

      // 获取服务器上变更的群成员版本信息
      final response = await datasyncGetSyncGroupMembersApi(
        IGetSyncGroupMembersReq(since: lastSyncTime),
      );
      if (response.code != 0 || response.result == null) {
        print('[GroupMemberSync] 获取群成员版本失败: ${response.msg}');
        return;
      }

      // 对比本地数据，过滤出需要更新的群组
      final needUpdateGroups = await _compareAndFilterMemberVersions(
        syncStatusService,
        response.result!.groupVersions,
      );

      if (needUpdateGroups.isNotEmpty) {
        // 有需要更新的群成员
        await _syncMemberData(
          groupMemberService,
          syncStatusService,
          needUpdateGroups,
        );
      }

      // 更新游标（无论是否有变更都要更新）
      await datasyncService.upsert(
        'group_members',
        -1, // 使用时间戳而不是版本号
        response.result!.serverTimestamp,
      );
    } catch (error) {
      print('[GroupMemberSync] 群成员同步失败: $error');
    }
  }

  /// 对比本地数据，过滤出需要更新的群组信息
  Future<List<IGroupVersionSyncItem>> _compareAndFilterMemberVersions(
    GroupSyncStatusService syncStatusService,
    List<IGroupMembersVersionItem> groupVersions,
  ) async {
    if (groupVersions.isEmpty) return [];

    // 提取所有变更的群组ID
    final groupIds = groupVersions.map((item) => item.groupId).toList();

    // 查询本地已存在的群成员版本状态
    final localVersions = await syncStatusService.getModuleVersions(
      'members',
      groupIds,
    );
    final localVersionMap = {
      for (var v in localVersions)
        (v['groupId'] as String): (v['version'] as int),
    };

    // 过滤出需要更新的群组，并使用本地版本号
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

  /// 同步群成员数据
  Future<void> _syncMemberData(
    GroupMemberService groupMemberService,
    GroupSyncStatusService syncStatusService,
    List<IGroupVersionSyncItem> groupsWithVersions,
  ) async {
    if (groupsWithVersions.isEmpty) return;

    // 直接使用传入的群组版本信息构造请求
    final response = await groupMemberSyncApi(
      IGroupMemberSyncReq(groups: groupsWithVersions),
    );
    if (response.code == 0 &&
        response.result != null &&
        response.result!.groupMembers.isNotEmpty) {
      final members = response.result!.groupMembers
          .map(
            (m) => GroupMembersCompanion(
              groupId: Value(m.groupId),
              userId: Value(m.userId),
              nickName: Value(m.nickName),
              avatar: Value(m.avatar),
              role: Value(m.role),
              status: Value(m.status),
              joinTime: Value(m.joinTime),
              version: Value(m.version),
              createdAt: Value(m.createdAt),
              updatedAt: Value(m.updatedAt),
            ),
          )
          .toList();

      await groupMemberService.batchCreate(members);

      // 更新本地群成员版本状态 (这里注意同步响应包里没有聚合版本，我们根据返回的 member 来更新)
      for (final member in response.result!.groupMembers) {
        await syncStatusService.upsertSyncStatus(
          module: 'members',
          groupId: member.groupId,
          version: member.version,
        );
      }

      // TODO: 发送通知到渲染进程
    }
  }
}

final groupMemberSync = GroupMemberSync();
