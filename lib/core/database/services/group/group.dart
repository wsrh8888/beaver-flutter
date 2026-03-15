import 'package:drift/drift.dart';
import 'package:beaver/core/database/app_database.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/group.dart';

class GroupService extends BaseService {
  GroupService(super.db);

  /// 批量同步群组信息
  Future<void> batchCreate(List<IGroupSyncItem> groups) async {
    await db.batch((batch) {
      for (final group in groups) {
        batch.insert(
          db.groups,
          GroupsCompanion(
            groupId: Value(group.groupId),
            title: Value(group.title),
            avatar: Value(group.avatar),
            creatorId: Value(group.creatorId),
            joinType: Value(group.joinType),
            status: Value(group.status),
            version: Value(group.version),
            createdAt: Value(group.createdAt),
            updatedAt: Value(group.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 获取所有群组同步状态
  Future<List<GroupSyncStatusData>> getAllGroupSyncStatus(String module) async {
    return (db.select(db.groupSyncStatus)..where((t) => t.module.equals(module))).get();
  }
  /// 批量更新群组同步状态
  Future<void> batchUpsertGroupSyncStatus(List<GroupSyncStatusCompanion> statusUpdates) async {
    await db.batch((batch) {
      for (final status in statusUpdates) {
        batch.insert(
          db.groupSyncStatus,
          status,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 获取指定模块和 ID 列表的同步版本 (替代 GroupSyncStatusService)
  Future<List<GroupSyncStatusData>> getModuleVersions(String module, List<String> groupIds) async {
    return (db.select(db.groupSyncStatus)
          ..where((t) => t.module.equals(module) & t.groupId.isIn(groupIds)))
        .get();
  }

  /// 更新单个群组同步状态
  Future<void> upsertSyncStatus({
    required String module,
    required String groupId,
    required int version,
  }) async {
    await db.into(db.groupSyncStatus).insert(
          GroupSyncStatusCompanion(
            groupId: Value(groupId),
            module: Value(module),
            version: Value(version),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
