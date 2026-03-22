import 'dart:async';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/core/database/db.dart';
import 'package:drift/drift.dart';

/// 群成员业务逻辑 (对标 PC business/group/group-member.ts)
class GroupMemberBusiness {
  final _groupMemberService = getIt<GroupMemberService>();

  /**
   * 按版本号同步群成员 (对标 PC processBatchRequests)
   */
  Future<void> syncGroupMembersByVersion(String groupId, int version) async {
    try {
      final response = await groupMemberSyncApi(
        IGroupMemberSyncReq(
          groups: [IGroupVersionSyncItem(groupId: groupId, version: version)],
        ),
      );

      if (response.code == 0 &&
          response.result != null &&
          response.result!.groupMembers.isNotEmpty) {
        final companions = response.result!.groupMembers
            .map(
              (member) => GroupMembersCompanion(
                groupId: Value(member.groupId),
                userId: Value(member.userId),
                role: Value(member.role),
                status: Value(member.status),
                joinTime: Value(member.joinTime ~/ 1000),
                version: Value(member.version),
              ),
            )
            .toList();

        await _groupMemberService.batchCreate(companions);
        print(
          '[GroupMemberBusiness] 群成员同步成功: count=${response.result!.groupMembers.length}',
        );
      }
    } catch (e) {
      print('[GroupMemberBusiness] syncGroupMembersByVersion failed: $e');
    }
  }

  Future<void> handleTableUpdates(
    String userId,
    String groupId,
    int version,
  ) async {
    await syncGroupMembersByVersion(groupId, version);
  }

  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    return await _groupMemberService.getGroupMembers(groupId);
  }
}
