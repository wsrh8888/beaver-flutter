import 'package:beaver/types/business/chat.dart';
import 'package:equatable/equatable.dart';

enum PrivateSettingStatus { initial, loading, success, error, deleted }

class PrivateSettingState extends Equatable {
  final PrivateSettingStatus status;
  final String conversationId;
  final ChatModel? conversation;
  final bool isSaving;
  final bool showDeleteDialog;
  final String? errorMessage;

  const PrivateSettingState({
    this.status = PrivateSettingStatus.initial,
    this.conversationId = '',
    this.conversation,
    this.isSaving = false,
    this.showDeleteDialog = false,
    this.errorMessage,
  });

  PrivateSettingState copyWith({
    PrivateSettingStatus? status,
    String? conversationId,
    ChatModel? conversation,
    bool? isSaving,
    bool? showDeleteDialog,
    String? errorMessage,
  }) {
    return PrivateSettingState(
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
