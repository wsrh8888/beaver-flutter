import 'package:drift/drift.dart';
import 'package:beaver/core/database/app_database.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/user.dart';

class UserService extends BaseService {
  UserService(super.db);

  /// 批量创建或更新用户
  Future<void> batchCreate(List<IUserSyncItem> users) async {
    await db.batch((batch) {
      for (final user in users) {
        batch.insert(
          db.users,
          UsersCompanion(
            userId: Value(user.userId),
            nickName: Value(user.nickName),
            email: Value(user.email),
            phone: Value(user.phone),
            avatar: Value(user.avatar),
            abstract: Value(user.abstract),
            gender: Value(user.gender),
            status: Value(user.status),
            version: Value(user.version),
            createdAt: Value(user.createdAt),
            updatedAt: Value(user.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 获取所有用户的同步状态
  Future<List<UserSyncStatusData>> getAllUsersSyncStatus() async {
    return db.select(db.userSyncStatus).get();
  }

  /// 批量更新用户同步状态
  Future<void> batchUpsertUserSyncStatus(List<UserSyncStatusCompanion> statusUpdates) async {
    await db.batch((batch) {
      for (final status in statusUpdates) {
        batch.insert(
          db.userSyncStatus,
          status,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}