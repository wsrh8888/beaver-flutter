import 'package:beaver/types/business/chat.dart';
import 'package:beaver/types/business/group.dart';
import 'package:equatable/equatable.dart';

enum GroupSettingStatus { initial, loading, success, error, deleted }

class GroupSettingState extends Equatable {
  final GroupSettingStatus status;
  final String conversationId;
  final ChatModel? conversation;
  final List<GroupMember> groupMembers;
  final String currentUserId;
  final bool isSaving;
  final bool showDeleteDialog;
  final String? errorMessage;

  const GroupSettingState({
    this.status = GroupSettingStatus.initial,
    this.conversationId = '',
    this.conversation,
    this.groupMembers = const [],
    this.currentUserId = '',
    this.isSaving = false,
    this.showDeleteDialog = false,
    this.errorMessage,
  });

  bool get isAdmin {
    if (currentUserId.isEmpty || groupMembers.isEmpty) return false;
    final self = groupMembers.where((m) => m.userId == currentUserId).firstOrNull;
    // role: 1=owner, 2=admin, 3=member
    return self != null && (self.role == 1 || self.role == 2);
  }

  GroupSettingState copyWith({
    GroupSettingStatus? status,
    String? conversationId,
    ChatModel? conversation,
    List<GroupMember>? groupMembers,
    String? currentUserId,
    bool? isSaving,
    bool? showDeleteDialog,
    String? errorMessage,
  }) {
    return GroupSettingState(
      status: status ?? this.status,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation ?? this.conversation,
      groupMembers: groupMembers ?? this.groupMembers,
      currentUserId: currentUserId ?? this.currentUserId,
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
        groupMembers,
        currentUserId,
        isSaving,
        showDeleteDialog,
        errorMessage,
      ];
}
