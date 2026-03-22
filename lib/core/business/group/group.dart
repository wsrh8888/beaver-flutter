import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/group.dart';
import 'package:drift/drift.dart';

/// Group business logic.
class GroupBusiness implements GroupRepositoryInterface {
  final _groupService = getIt<GroupService>();
  final _groupMemberService = getIt<GroupMemberService>();
  final _friendBusiness = getIt<FriendBusiness>();

  @override
  Future<List<Contact>?> getContacts() async {
    final friends = await _friendBusiness.getContactList();
    return friends
        .map(
          (item) => Contact(
            userId: item.userId,
            nickname:
                item.notice?.isNotEmpty == true ? item.notice! : item.nickname,
            fileName:
                item.avatar?.isNotEmpty == true
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
    memberIds.add(currentUserId);

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final now = nowMs ~/ 1000;
    final groupId = 'group_$nowMs';

    await _groupService.upsert(
      GroupsCompanion(
        groupId: Value(groupId),
        title: const Value('新群聊'),
        avatar: const Value(''),
        creatorId: Value(currentUserId),
        joinType: const Value(0),
        status: const Value(1),
        version: const Value(0),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    final members =
        memberIds
            .map(
              (userId) => GroupMembersCompanion(
                groupId: Value(groupId),
                userId: Value(userId),
                role: Value(userId == currentUserId ? 1 : 3),
                status: const Value(1),
                joinTime: Value(now),
                version: const Value(0),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            )
            .toList();

    await _groupMemberService.batchCreate(members);
    return groupId;
  }

  @override
  Future<List<GroupInfo>?> getGroupList() async {
    final groups = await _groupService.getActiveGroups();
    if (groups.isEmpty) {
      return [];
    }

    final result = <GroupInfo>[];
    for (final group in groups) {
      final members = await _groupMemberService.getGroupMembers(group.groupId);
      result.add(
        GroupInfo(
          conversationId: group.groupId,
          title: group.title,
          fileName: group.avatar,
          lastMessage: group.notice ?? '',
          memberCount: members.length,
        ),
      );
    }
    return result;
  }
}
