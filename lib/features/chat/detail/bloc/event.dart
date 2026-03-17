import 'package:beaver/core/database/database.dart';
import 'package:beaver/features/chat/detail/data/models/types.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class LoadMessagesEvent extends ChatEvent {
  final String conversationId;

  const LoadMessagesEvent(this.conversationId);
}

class LoadMoreMessagesEvent extends ChatEvent {
  const LoadMoreMessagesEvent();
}

class SendMessageEvent extends ChatEvent {
  final String content;
  final MessageType type;

  const SendMessageEvent(this.content, this.type);
}

class UpdateMessageStatusEvent extends ChatEvent {
  final String messageId;
  final MessageStatus status;

  const UpdateMessageStatusEvent(this.messageId, this.status);
}

class MessageReceivedEvent extends ChatEvent {
  final String conversationId;

  const MessageReceivedEvent(this.conversationId);
}
