import 'dart:async';
import 'package:beaver/core/database/services/group/group_join_request.dart';
import 'package:beaver/core/database/services/group/group.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/types/business/group.dart';
import 'package:intl/intl.dart';

/// 群加入请求业务逻辑 (对标 PC business/group/group-join-request.ts)
class GroupJoinRequestBusiness {
  final _joinRequestService = getIt<GroupJoinRequestService>();
  final _groupService = getIt<GroupService>();
  final _userBusiness = getIt<UserBusiness>();

  Future<void> handleTableUpdates(String userId, String groupId, int version) async {
    await syncGroupJoinRequestsByVersion(groupId, version);
  }

  Future<void> syncGroupJoinRequestsByVersion(String groupId, int version) async {
     try {
      final response = await groupJoinRequestSyncApi(
        IGroupJoinRequestSyncReq(
          groups: [IGroupVersionSyncItem(groupId: groupId, version: version)],
        ),
      );

      if (response.code == 0 && response.result != null && response.result!.groupJoinRequests.isNotEmpty) {
        await _joinRequestService.batchCreate(response.result!.groupJoinRequests);
        print('[GroupJoinRequestBusiness] 入群申请同步成功: count=${response.result!.groupJoinRequests.length}');
      }
    } catch (e) {
      print('[GroupJoinRequestBusiness] syncGroupJoinRequestsByVersion failed: $e');
    }
  }

  Future<List<GroupNotification>> getGroupNotifications() async {
    final requests = await _joinRequestService.getAllRequests();
    if (requests.isEmpty) return [];

    final groupIds = requests.map((r) => r.groupId).toSet().toList();
    final userIds = requests.map((r) => r.applicantUserId).toSet().toList();

    final groups = await _groupService.getGroupsByIds(groupIds);
    final groupMap = {for (var g in groups) g.groupId: g};

    final userInfos = await _userBusiness.getUsersBasicInfo(userIds);
    final userMap = {for (var u in userInfos) u.userId: u};

    final notifications = requests.map((r) {
      final group = groupMap[r.groupId];
      final user = userMap[r.applicantUserId];

      final createdAt = r.createdAt != null
          ? DateFormat(
              'yyyy-MM-dd HH:mm',
            ).format(DateTime.fromMillisecondsSinceEpoch(r.createdAt! * 1000))
          : '';

      return GroupNotification(
        id: r.id,
        groupId: r.groupId,
        groupName: group?.title ?? '未知群聊',
        groupAvatar: group?.avatar ?? '',
        applicantUserId: r.applicantUserId,
        applicantNickname: user?.nickname ?? r.applicantUserId,
        applicantAvatar: user?.avatar ?? '',
        message: r.message,
        status: r.status,
        createdAt: createdAt,
      );
    }).toList();

    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications;
  }

  Future<bool> updateGroupRequestStatus(int id, int status) async {
    return true;
  }

  Future<int> getUnreadGroupNotificationCount() async {
    return await _joinRequestService.getUnreadCount();
  }
}
