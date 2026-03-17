import 'package:beaver/features/chat/detail/data/models/message.dart';
import 'package:beaver/core/database/database.dart';

enum ChatStatus { initial, loading, success, error, sending }

class ChatState {
  final ChatStatus status;
  final List<MessageModel> messages;
  final ChatConversation? conversation;
  final String? conversationId;
  final String? errorMessage;
  final bool hasMore;
  final bool isLoadingMore;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.conversation,
    this.conversationId,
    this.errorMessage,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<MessageModel>? messages,
    ChatConversation? conversation,
    String? conversationId,
    String? errorMessage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      conversation: conversation ?? this.conversation,
      conversationId: conversationId ?? this.conversationId,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
