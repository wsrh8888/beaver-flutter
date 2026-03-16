class GroupInfo {
  final String conversationId;
  final String title;
  final String fileName;
  final String? lastMessage;
  final int memberCount;

  const GroupInfo({
    required this.conversationId,
    required this.title,
    required this.fileName,
    this.lastMessage,
    required this.memberCount,
  });
}
