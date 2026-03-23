import 'package:beaver/types/business/chat.dart';

enum ChatListStatus { initial, loading, success, error }

class ChatListState {
  final ChatListStatus status;
  final List<ChatModel>? chats;
  final List<ChatModel>? pinnedChats;
  final String? errorMessage;

  const ChatListState({
    this.status = ChatListStatus.initial,
    this.chats,
    this.pinnedChats,
    this.errorMessage,
  });

  ChatListState copyWith({
    ChatListStatus? status,
    List<ChatModel>? chats,
    List<ChatModel>? pinnedChats,
    String? errorMessage,
  }) {
    return ChatListState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      pinnedChats: pinnedChats ?? this.pinnedChats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
