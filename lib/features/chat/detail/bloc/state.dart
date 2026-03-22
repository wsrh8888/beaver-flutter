import 'package:beaver/types/business/message.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';

enum ChatStatus { initial, loading, success, error, sending }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<MessageModel> messages;
  final dynamic conversation;
  final String? conversationId;
  final String? errorMessage;
  final bool hasMore;
  final bool isLoadingMore;
  final String draft;
  final ComposerPanelType activePanel;
  final bool isSending;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.conversation,
    this.conversationId,
    this.errorMessage,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.draft = '',
    this.activePanel = ComposerPanelType.none,
    this.isSending = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<MessageModel>? messages,
    dynamic? conversation,
    String? conversationId,
    String? errorMessage,
    bool? hasMore,
    bool? isLoadingMore,
    String? draft,
    ComposerPanelType? activePanel,
    bool? isSending,
    bool clearError = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      conversation: conversation ?? this.conversation,
      conversationId: conversationId ?? this.conversationId,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      draft: draft ?? this.draft,
      activePanel: activePanel ?? this.activePanel,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        conversation,
        conversationId,
        errorMessage,
        hasMore,
        isLoadingMore,
        draft,
        activePanel,
        isSending,
      ];
}
