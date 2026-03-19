import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class GroupMemberService extends BaseService {
  GroupMemberService(super.db);

  /// 创建或更新群成员（upsert操作）
  Future<void> upsert(GroupMembersCompanion member) async {
    await db.into(db.groupMembers).insert(
      member,
      mode: InsertMode.insertOrReplace,
    );
  }

  /// 批量创建群成员（支持插入或更新）
  Future<void> batchCreate(List<GroupMembersCompanion> members) async {
    if (members.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final member in members) {
        batch.insert(
          db.groupMembers,
          member,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 获取群成员列表（纯数据库查询，不含业务逻辑）
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    return (db.select(db.groupMembers)..where((t) => t.groupId.equals(groupId) & t.status.equals(1))).get();
  }

  /// 获取用户加入的群组成员记录（纯数据库查询，不含业务逻辑）
  Future<List<GroupMember>> getUserMemberships(String userId) async {
    return (db.select(db.groupMembers)..where((t) => t.userId.equals(userId) & t.status.equals(1))).get();
  }
}
