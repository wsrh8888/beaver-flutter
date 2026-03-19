import 'package:beaver/types/business/message.dart';

enum ChatStatus { initial, loading, success, error, sending }

class ChatState {
  final ChatStatus status;
  final List<MessageModel> messages;
  final dynamic conversation;
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
    dynamic? conversation,
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
