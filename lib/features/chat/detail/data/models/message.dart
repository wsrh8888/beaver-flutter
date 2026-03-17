import 'package:beaver/core/database/database.dart';
import 'package:beaver/features/chat/detail/data/models/types.dart';

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

  factory MessageModel.fromMessage(Message message, bool isSent) {
    return MessageModel(
      id: message.id,
      conversationId: message.conversationId,
      userId: message.senderId,
      content: message.content,
      type: message.type,
      status: message.status,
      createdAt: message.createdAt,
      isSent: isSent,
    );
  }

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
