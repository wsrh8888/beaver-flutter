import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class GroupSyncStatusService extends BaseService {
  GroupSyncStatusService(super.db);

  /// 批量获取指定模块的版本状态
  Future<List<Map<String, dynamic>>> getModuleVersions(String module, List<String> groupIds) async {
    if (groupIds.isEmpty) {
      return [];
    }

    final statuses = await (db.select(db.groupSyncStatus)
          ..where((t) => t.module.equals(module) & t.groupId.isIn(groupIds)))
        .get();

    final versions = statuses.map((status) => {
          'groupId': status.groupId,
          'version': status.version ?? 0,
        }).toList();

    return versions;
  }

  /// 更新指定模块的同步状态
  Future<void> upsertSyncStatus({
    required String module,
    required String groupId,
    required int version,
  }) async {
    await db.into(db.groupSyncStatus).insert(
          GroupSyncStatusCompanion(
            module: Value(module),
            groupId: Value(groupId),
            version: Value(version),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
