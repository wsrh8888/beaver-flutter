import 'package:beaver/features/chat/chat_list/data/models/chat.dart';

abstract class ChatListEvent {
  const ChatListEvent();
}

class LoadChatListEvent extends ChatListEvent {
  const LoadChatListEvent();
}

class TogglePinChatEvent extends ChatListEvent {
  final String conversationId;
  final bool isPinned;

  const TogglePinChatEvent({
    required this.conversationId,
    required this.isPinned,
  });
}

class DeleteChatEvent extends ChatListEvent {
  final String conversationId;

  const DeleteChatEvent({required this.conversationId});
}

class ChatListUpdatedEvent extends ChatListEvent {
  final List<ChatModel> chats;

  const ChatListUpdatedEvent({required this.chats});
}
