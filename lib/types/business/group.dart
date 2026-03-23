/// 群组信息模型
class GroupInfo {
  final String conversationId;
  final String title;
  final String avatar;
  final String fileName;
  final String lastMessage;
  final int memberCount;
  final int version;

  const GroupInfo({
    required this.conversationId,
    required this.title,
    required this.avatar,
    required this.fileName,
    required this.lastMessage,
    required this.memberCount,
    required this.version,
  });
}

/// 联系人模型
class Contact {
  final String userId;
  final String nickname;
  final String fileName;
  final String status;

  const Contact({
    required this.userId,
    required this.nickname,
    required this.fileName,
    required this.status,
  });
}

/// 群组仓库接口
abstract class GroupRepositoryInterface {
  Future<List<Contact>?> getContacts();
  Future<String> createGroup(List<String> userIds);
  Future<List<GroupInfo>?> getGroupList();
  Future<List<GroupNotification>> getGroupNotifications();
  Future<bool> updateGroupRequestStatus(int id, int status);
  Future<int> getUnreadGroupNotificationCount(String userId);
}

class GroupNotification {
  final int id;
  final String groupId;
  final String groupName;
  final String groupAvatar;
  final String applicantUserId;
  final String applicantNickname;
  final String applicantAvatar;
  final String? message;
  final int status; // 0: pending, 1: accepted, 2: rejected
  final String createdAt;

  const GroupNotification({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.groupAvatar,
    required this.applicantUserId,
    required this.applicantNickname,
    required this.applicantAvatar,
    this.message,
    required this.status,
    required this.createdAt,
  });
}

/// 群成员业务模型
class GroupMember {
  final String groupId;
  final String userId;
  final int role;
  final int status;
  final int joinTime;
  final int version;

  const GroupMember({
    required this.groupId,
    required this.userId,
    required this.role,
    required this.status,
    required this.joinTime,
    required this.version,
  });
}