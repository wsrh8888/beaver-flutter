import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class UserSyncStatusService extends BaseService {
  const UserSyncStatusService();

  /// 获取用户同步状态
  Future<UserSyncStatusData?> getUserSyncStatus(String userId) async {
    return (db.select(db.userSyncStatus)..where((t) => t.userId.equals(userId))).getSingleOrNull();
  }

  /// 批量获取用户同步状态
  Future<List<UserSyncStatusData>> getUsersSyncStatus(List<String> userIds) async {
    if (userIds.isEmpty) {
      return [];
    }
    return (db.select(db.userSyncStatus)..where((t) => t.userId.isIn(userIds))).get();
  }

  /// 获取所有用户同步状态
  Future<List<UserSyncStatusData>> getAllUsersSyncStatus() async {
    return db.select(db.userSyncStatus).get();
  }

  /// 更新或插入用户同步状态
  Future<void> upsertUserSyncStatus(String userId, int userVersion) async {
    await db.into(db.userSyncStatus).insert(
          UserSyncStatusCompanion(
            userId: Value(userId),
            userVersion: Value(userVersion),
            lastSyncTime: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  /// 批量更新用户同步状态
  Future<void> batchUpsertUserSyncStatus(List<Map<String, dynamic>> statuses) async {
    await db.batch((batch) {
      for (final status in statuses) {
        batch.insert(
          db.userSyncStatus,
          UserSyncStatusCompanion(
            userId: Value(status['userId'] as String),
            userVersion: Value(status['userVersion'] as int),
            lastSyncTime: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 删除用户同步状态
  Future<void> deleteUserSyncStatus(String userId) async {
    await (db.delete(db.userSyncStatus)..where((t) => t.userId.equals(userId))).go();
  }

  /// 批量删除用户同步状态
  Future<void> batchDeleteUserSyncStatus(List<String> userIds) async {
    if (userIds.isEmpty) {
      return;
    }
    await (db.delete(db.userSyncStatus)..where((t) => t.userId.isIn(userIds))).go();
  }

  /// 清空所有同步状态（用于重置）
  Future<void> clearAllSyncStatus() async {
    await db.delete(db.userSyncStatus).go();
  }

  /// 获取需要同步的用户列表
  Future<List<String>> getUsersNeedSync(Map<String, int> serverVersions) async {
    final localStatuses = await getAllUsersSyncStatus();
    final statusMap = <String, UserSyncStatusData>{};
    for (final status in localStatuses) {
      statusMap[status.userId] = status;
    }

    final needSync = <String>[];
    for (final entry in serverVersions.entries) {
      final userId = entry.key;
      final serverVersion = entry.value;
      final localStatus = statusMap[userId];
      final localVersion = localStatus?.userVersion ?? 0;

      if (localVersion < serverVersion) {
        needSync.add(userId);
      }
    }

    return needSync;
  }
}
