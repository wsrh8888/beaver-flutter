import 'dart:async';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/group.dart';
import 'package:drift/drift.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/core/business/group/group_join_request.dart';
import 'package:beaver/core/business/group/group_member.dart';

const int groupStatusActive = 1;

/// Group business logic.
class GroupBusiness implements GroupRepositoryInterface {
  final _groupService = getIt<GroupService>();
  final _groupMemberService = getIt<GroupMemberService>();
  final _friendBusiness = getIt<FriendBusiness>();

  // 响应式数据流 (对标 PC 的 Notification 机制)
  final _groupUpdateController = StreamController<List<String>>.broadcast();
  Stream<List<String>> get groupUpdateStream => _groupUpdateController.stream;

  void notifyGroupUpdate(List<String> groupIds) {
    print('[GroupBusiness] 发送群组更新通知: $groupIds');
    _groupUpdateController.add(groupIds);
  }

  @override
  Future<List<Contact>?> getContacts() async {
    final friends = await _friendBusiness.getContactList();
    return friends
        .map(
          (item) => Contact(
            userId: item.userId,
            nickname: item.notice?.isNotEmpty == true
                ? item.notice!
                : item.nickname,
            fileName: item.avatar?.isNotEmpty == true
                ? item.avatar!
                : (item.fileName ?? ''),
            status: '',
          ),
        )
        .toList();
  }

  @override
  Future<String> createGroup(List<String> userIds) async {
    final currentUserId = DatabaseManager.currentUserId ?? '';
    if (currentUserId.isEmpty) {
      throw StateError('currentUserId is empty');
    }

    final memberIds = userIds.where((id) => id.trim().isNotEmpty).toSet();

    // Call API First
    final req = IGroupCreateReq(title: '新群聊', userIdList: memberIds.toList());

    final response = await createGroupApi(req);

    if (response.code != 0 || response.result == null) {
      throw Exception(response.msg);
    }

    final groupId = response.result!.groupId;

    // Note: 我们不再在这里进行本地落库逻辑，而是等待服务器的 WS 推送 (GROUP_OPERATION)。
    // 这确保了会话列表只有在服务器确认后才会显示真实数据，避免竞态。
    return groupId;
  }

  @override
  Future<List<GroupInfo>?> getGroupList() async {
    final userId = DatabaseManager.currentUserId ?? '';
    if (userId.isEmpty) {
      return [];
    }

    final memberships = await _groupMemberService.getUserMemberships(userId);
    if (memberships.isEmpty) {
      return [];
    }

    final groupIds = memberships.map((m) => m.groupId).toList();
    final groups = await _groupService.getGroupsByIds(groupIds);
    final activeGroups =
        groups.where((group) => group.status == groupStatusActive).toList();

    final result = <GroupInfo>[];
    for (final group in activeGroups) {
      final memberCount =
          await getIt<GroupMemberBusiness>().countHumanMembers(group.groupId);
      result.add(
        GroupInfo(
          conversationId: 'group_${group.groupId}',
          title: group.title,
          avatar: group.avatar,
          fileName: group.avatar,
          lastMessage: group.notice ?? '',
          memberCount: memberCount,
          version: group.version,
        ),
      );
    }
    return result;
  }

  @override
  Future<List<GroupNotification>> getGroupNotifications() =>
      getIt<GroupJoinRequestBusiness>().getGroupNotifications();

  @override
  Future<bool> updateGroupRequestStatus(int id, int status) =>
      getIt<GroupJoinRequestBusiness>().updateGroupRequestStatus(id, status);

  @override
  Future<int> getUnreadGroupNotificationCount(String userId) =>
      getIt<GroupJoinRequestBusiness>().getUnreadGroupNotificationCount();

  /**
   * 按版本号同步群资料 (对标 PC syncGroupByVersion)
   */
  Future<List<GroupInfo>?> getGroupsByIds(List<String> groupIds) async {
    try {
      final userId = DatabaseManager.currentUserId ?? '';
      if (userId.isEmpty || groupIds.isEmpty) {
        return [];
      }

      final memberships = await _groupMemberService.getUserMemberships(userId);
      final activeGroupIds = memberships.map((m) => m.groupId).toSet();
      final groups = await _groupService.getGroupsByIds(groupIds);
      final List<GroupInfo> result = [];
      for (final g in groups) {
        if (!activeGroupIds.contains(g.groupId)) {
          continue;
        }
        if (g.status != groupStatusActive) {
          continue;
        }
        final memberCount =
            await getIt<GroupMemberBusiness>().countHumanMembers(g.groupId);
        result.add(
          GroupInfo(
            conversationId: 'group_${g.groupId}',
            title: g.title,
            avatar: g.avatar,
            fileName: g.avatar,
            lastMessage: '',
            memberCount: memberCount,
            version: g.version,
          ),
        );
      }
      return result;
    } catch (e) {
      print('GroupBusiness: getGroupsByIds 失败: $e');
      rethrow;
    }
  }

  Future<bool> isGroupConversationActive(String conversationId) async {
    if (!conversationId.startsWith('group_')) {
      return true;
    }
    final groupId = conversationId.replaceFirst('group_', '');
    if (groupId.isEmpty) {
      return true;
    }
    final groups = await getGroupsByIds([groupId]);
    return groups.isNotEmpty;
  }

  Future<void> syncGroupByVersion(String groupId, int version) async {
    try {
      final response = await groupSyncApi(
        IGroupSyncReq(
          groups: [IGroupVersionSyncItem(groupId: groupId, version: version)],
        ),
      );

      if (response.code == 0 &&
          response.result != null &&
          response.result!.groups.isNotEmpty) {
        final group = response.result!.groups.first;
        await _groupService.upsert(
          GroupsCompanion(
            groupId: Value(group.groupId),
            title: Value(group.title),
            avatar: Value(group.avatar),
            creatorId: Value(group.creatorId),
            joinType: Value(group.joinType),
            status: Value(group.status),
            notice: Value(group.notice),
            version: Value(group.version),
            createdAt: Value(
              group.createdAt ??
                  (DateTime.now().millisecondsSinceEpoch ~/ 1000),
            ),
            updatedAt: Value(
              group.updatedAt ??
                  (DateTime.now().millisecondsSinceEpoch ~/ 1000),
            ),
          ),
        );

        // 更新本地群组版本状态
        final syncStatusService = getIt<GroupSyncStatusService>();
        await syncStatusService.upsertSyncStatus(
          module: 'info',
          groupId: group.groupId,
          version: group.version,
        );

        notifyGroupUpdate([group.groupId]);
        getIt<ConversationBusiness>().notifyConversationUpdate();
      }
    } catch (e) {
      print('[GroupBusiness] syncGroupByVersion failed: $e');
    }
  }
}
