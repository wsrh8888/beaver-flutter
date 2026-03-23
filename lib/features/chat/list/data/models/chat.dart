class ChatModel {
  final String conversationId;
  final String nickname;
  final String? avatar;
  final String msgPreview;
  final String updateAt;
  final bool isTop;
  final int unreadCount;

  const ChatModel({
    required this.conversationId,
    required this.nickname,
    this.avatar,
    required this.msgPreview,
    required this.updateAt,
    this.isTop = false,
    this.unreadCount = 0,
  });

  ChatModel copyWith({
    String? conversationId,
    String? nickname,
    String? avatar,
    String? msgPreview,
    String? updateAt,
    bool? isTop,
    int? unreadCount,
  }) {
    return ChatModel(
      conversationId: conversationId ?? this.conversationId,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      msgPreview: msgPreview ?? this.msgPreview,
      updateAt: updateAt ?? this.updateAt,
      isTop: isTop ?? this.isTop,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
