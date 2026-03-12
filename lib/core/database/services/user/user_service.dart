import 'package:drift/drift.dart';

import '../../app_database.dart';
import '../base.dart';

/// 用户表数据访问
class UserService extends BaseService {
  const UserService(super.db);
  /// 插入或更新用户 (userId 唯一冲突时替换)
  Future<void> upsert(UsersCompanion row) async {
    await db.into(db.users).insert(row, mode: InsertMode.insertOrReplace);
  }

  /// 根据 userId 查询
  Future<User?> getByUserId(String userId) async {
    return await (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingleOrNull();
  }

  /// 批量根据 userId 查询 (用于消息发送者信息等)
  Future<List<User>> getByUserIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];
    return await (db.select(db.users)..where((t) => t.userId.isIn(userIds))).get();
  }

  /// 查询所有用户
  Future<List<User>> getAll() async {
    return await db.select(db.users).get();
  }
}
