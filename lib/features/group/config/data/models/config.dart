class GroupInfo {
  final String groupId;
  final String title;
  final String fileName;
  final int memberCount;

  const GroupInfo({
    required this.groupId,
    required this.title,
    required this.fileName,
    required this.memberCount,
  });
}

class GroupMember {
  final String userId;
  final String nickname;
  final String fileName;
  final int role; // 0: 普通成员, 1: 管理员, 2: 群主

  const GroupMember({
    required this.userId,
    required this.nickname,
    required this.fileName,
    required this.role,
  });
}
