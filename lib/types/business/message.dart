/// 消息类型枚举
enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  emoji,
  notification,
  recalled,
  reply,
  mergedForward,
  call,
  system,
}

/// 消息状态枚举
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

/// 消息仓库接口
abstract class MessageRepositoryInterface {
  Future<List<MessageModel>> getMessages(String conversationId, {int limit = 50, int offset = 0});
  Future<MessageModel> sendMessage(String conversationId, String content, MessageType type);
  Future<void> updateMessageStatus(String messageId, MessageStatus status);
  Future<dynamic> getConversation(String conversationId);
  Stream<List<MessageModel>> watchMessages(String conversationId);
}

/// 消息模型 (UI格式)
class MessageModel {
  final String id;
  final String conversationId;
  final String userId;
  final String? nickname;
  final String? avatar;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime createdAt;
  final bool isSent;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.userId,
    this.nickname,
    this.avatar,
    required this.content,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.isSent,
  });

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? userId,
    String? nickname,
    String? avatar,
    String? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? createdAt,
    bool? isSent,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isSent: isSent ?? this.isSent,
    );
  }
}