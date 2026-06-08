import 'package:equatable/equatable.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/types/business/chat.dart';

enum ChatStatus { initial, loading, success, error, multiSelect }
enum ComposerPanelType { none, emoji, package }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<MessageModel> messages;
  final ChatModel? conversation;
  final String? conversationId;
  final String? errorMessage;
  final bool isLoadingMore;
  final bool hasMore;
  final String draft;
  final ComposerPanelType activePanel;
  final bool isVoiceMode;
  final bool isSending;
  final Set<String> selectedMessageIds;
  final MessageModel? editingMessage;
  final MessageModel? replyingMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.conversation,
    this.conversationId,
    this.errorMessage,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.draft = '',
    this.activePanel = ComposerPanelType.none,
    this.isVoiceMode = false,
    this.isSending = false,
    this.selectedMessageIds = const {},
    this.editingMessage,
    this.replyingMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<MessageModel>? messages,
    dynamic conversation,
    String? conversationId,
    String? errorMessage,
    bool? isLoadingMore,
    bool? hasMore,
    String? draft,
    ComposerPanelType? activePanel,
    bool? isVoiceMode,
    bool? isSending,
    Set<String>? selectedMessageIds,
    MessageModel? editingMessage,
    MessageModel? replyingMessage,
    bool clearEditingMessage = false,
    bool clearReplyingMessage = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      conversation: conversation ?? this.conversation,
      conversationId: conversationId ?? this.conversationId,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      draft: draft ?? this.draft,
      activePanel: activePanel ?? this.activePanel,
      isVoiceMode: isVoiceMode ?? this.isVoiceMode,
      isSending: isSending ?? this.isSending,
      selectedMessageIds: selectedMessageIds ?? this.selectedMessageIds,
      editingMessage: clearEditingMessage
          ? null
          : (editingMessage ?? this.editingMessage),
      replyingMessage: clearReplyingMessage
          ? null
          : (replyingMessage ?? this.replyingMessage),
    );
  }

  @override
  List<Object?> get props => [
    status, messages, conversation, conversationId, errorMessage, 
    isLoadingMore, hasMore, draft, activePanel, isVoiceMode, isSending, selectedMessageIds,
    editingMessage, replyingMessage,
  ];
}
