/// 消息类型枚举
enum MessageType {
  text,
  image,
  video,
  audio,
  file,
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

/// 消息模型 (UI格式)
class MessageModel {
  final String id;
  final String conversationId;
  final String userId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime createdAt;
  final bool isSent;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.userId,
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
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isSent: isSent ?? this.isSent,
    );
  }
}