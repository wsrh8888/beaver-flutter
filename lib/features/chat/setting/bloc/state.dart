import 'package:beaver/types/business/chat.dart';
import 'package:equatable/equatable.dart';

enum ChatSettingStatus { initial, loading, success, error, deleted }

class ChatSettingState extends Equatable {
  final ChatSettingStatus status;
  final String conversationId;
  final ChatModel? conversation;
  final bool isSaving;
  final bool showDeleteDialog;
  final String? errorMessage;

  const ChatSettingState({
    this.status = ChatSettingStatus.initial,
    this.conversationId = '',
    this.conversation,
    this.isSaving = false,
    this.showDeleteDialog = false,
    this.errorMessage,
  });

  ChatSettingState copyWith({
    ChatSettingStatus? status,
    String? conversationId,
    ChatModel? conversation,
    bool? isSaving,
    bool? showDeleteDialog,
    String? errorMessage,
  }) {
    return ChatSettingState(
      status: status ?? this.status,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation ?? this.conversation,
      isSaving: isSaving ?? this.isSaving,
      showDeleteDialog: showDeleteDialog ?? this.showDeleteDialog,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversationId,
        conversation,
        isSaving,
        showDeleteDialog,
        errorMessage,
      ];
}
