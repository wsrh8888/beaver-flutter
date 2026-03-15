import 'package:drift/drift.dart';
import 'package:beaver/core/database/app_database.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/group.dart';

class GroupMemberService extends BaseService {
  GroupMemberService(super.db);

  /// 批量创建群成员
  Future<void> batchCreate(List<IGroupMemberSyncItem> members) async {
    await db.batch((batch) {
      for (final member in members) {
        batch.insert(
          db.groupMembers,
          GroupMembersCompanion(
            groupId: Value(member.groupId),
            userId: Value(member.userId),
            nickName: Value(member.nickName),
            avatar: Value(member.avatar),
            role: Value(member.role),
            status: Value(member.status),
            joinTime: Value(member.joinTime),
            version: Value(member.version),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}

class GroupJoinRequestService extends BaseService {
  GroupJoinRequestService(super.db);

  /// 批量创建入群申请
  Future<void> batchCreate(List<IGroupJoinRequestSyncItem> requests) async {
    await db.batch((batch) {
      for (final req in requests) {
        batch.insert(
          db.groupJoinRequests,
          GroupJoinRequestsCompanion(
            id: Value(req.id), // id is already int in IGroupJoinRequestSyncItem
            groupId: Value(req.groupId),
            applicantUserId: Value(req.applicantUserId),
            message: Value(req.message),
            status: Value(req.status),
            version: Value(req.version),
            createdAt: Value(req.createdAt),
            updatedAt: Value(req.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}
