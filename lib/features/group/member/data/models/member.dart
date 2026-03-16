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

class Contact {
  final String userId;
  final String nickname;
  final String fileName;

  const Contact({
    required this.userId,
    required this.nickname,
    required this.fileName,
  });
}
