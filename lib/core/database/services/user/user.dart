import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/user.dart';

class UserService extends BaseService {
  UserService(super.db);

  /// 创建用户
  Future<void> create(UsersCompanion user) async {
    await db.into(db.users).insert(user);
  }

  /// 创建或更新用户（upsert操作）
  Future<void> upsert(UsersCompanion user) async {
    await db.into(db.users).insert(
          user,
          mode: InsertMode.insertOrReplace,
        );
  }

  /// 批量创建用户（调用upsert方法，避免重复数据错误）
  Future<void> batchCreate(List<IUserSyncItem> users) async {
    if (users.isEmpty) {
      return;
    }

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

  /// 根据用户ID获取用户信息
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final userData = await (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingleOrNull();
    
    if (userData == null) {
      return null;
    }

    return {
      'userInfo': {
        'userId': userData.userId,
        'nickName': userData.nickName,
        'avatar': userData.avatar ?? '',
        'abstract': userData.abstract ?? '',
        'phone': userData.phone,
        'email': userData.email,
        'gender': userData.gender ?? 0,
        'version': userData.version,
      }
    };
  }

  /// 根据用户ID获取用户基本信息（包括版本号）
  Future<Map<String, dynamic>?> getUserBasicInfo(String userId) async {
    final userData = await (db.select(db.users)
          ..where((t) => t.userId.equals(userId))
          ..map((row) => {
                'userId': row.userId,
                'version': row.version,
              }))
        .getSingleOrNull();

    if (userData == null) {
      return null;
    }

    return {'userInfo': userData};
  }

  /// 批量获取用户基本信息（用于消息发送者信息）
  Future<List<Map<String, dynamic>>> getUsersBasicInfo(List<String> userIds) async {
    if (userIds.isEmpty) {
      return [];
    }

    final userData = await (db.select(db.users)..where((t) => t.userId.isIn(userIds))).get();

    return userData.map((user) => {
          'userId': user.userId,
          'nickName': user.nickName,
          'avatar': user.avatar ?? '',
        }).toList();
  }

  /// 获取所有用户基本信息（用于contactStore初始化）
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final userData = await db.select(db.users).get();

    return userData.map((user) => {
          'userId': user.userId,
          'nickName': user.nickName,
          'avatar': user.avatar ?? '',
          'abstract': user.abstract ?? '',
          'phone': user.phone ?? '',
          'email': user.email ?? '',
          'gender': user.gender ?? 0,
          'status': user.status ?? 0,
          'version': user.version ?? 0,
          'createdAt': user.createdAt ?? 0,
          'updatedAt': user.updatedAt ?? 0,
        }).toList();
  }

  /// 根据 userId 获取用户
  Future<User?> getUserByUserId(String userId) async {
    return (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingleOrNull();
  }
}