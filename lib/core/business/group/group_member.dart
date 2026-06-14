import 'dart:async';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/types/business/group.dart';

const int _userTypeNormal = 1;

/// 群成员业务逻辑 (对标 PC business/group/group-member.ts)
class GroupMemberBusiness {
  final _groupMemberService = getIt<GroupMemberService>();
  final _userService = getIt<UserService>();

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
        await _groupMemberService.batchCreateFromApi(response.result!.groupMembers);
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

  /// 获取群成员（仅返回普通用户，不含 bot/robot）
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    final dbMembers = await _groupMemberService.getGroupMembers(groupId);
    if (dbMembers.isEmpty) {
      return [];
    }

    final userIds = dbMembers.map((m) => m.userId).toList();
    final userInfos = await _userService.getUsersBasicInfo(userIds);
    final userTypeMap = {
      for (final user in userInfos)
        user['userId'] as String: user['userType'] as int,
    };

    return dbMembers
        .where((member) => userTypeMap[member.userId] == _userTypeNormal)
        .map((dbMember) => GroupMember(
              groupId: dbMember.groupId,
              userId: dbMember.userId,
              nickname: dbMember.nickName,
              avatar: dbMember.avatar,
              role: dbMember.role,
              status: dbMember.status,
              joinTime: dbMember.joinTime ??
                  DateTime.now().millisecondsSinceEpoch ~/ 1000,
              version: dbMember.version,
            ))
        .toList();
  }

  /// 统计群内普通用户数量
  Future<int> countHumanMembers(String groupId) async {
    final members = await getGroupMembers(groupId);
    return members.length;
  }
}
