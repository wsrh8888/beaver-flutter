/// 群组信息模型
class GroupInfo {
  final String conversationId;
  final String title;
  final String fileName;
  final String lastMessage;
  final int memberCount;

  const GroupInfo({
    required this.conversationId,
    required this.title,
    required this.fileName,
    required this.lastMessage,
    required this.memberCount,
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
}