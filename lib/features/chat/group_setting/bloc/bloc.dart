import 'package:beaver/api/group.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/core/business/group/group_member.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/group_setting/bloc/event.dart';
import 'package:beaver/features/chat/group_setting/bloc/state.dart';
import 'package:beaver/types/api/group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSettingBloc extends Bloc<GroupSettingEvent, GroupSettingState> {
  final _conversationBusiness = getIt<ConversationBusiness>();
  final _groupMemberBusiness = getIt<GroupMemberBusiness>();

  GroupSettingBloc() : super(const GroupSettingState()) {
    on<InitGroupSettingEvent>(_onInit);
    on<TogglePinGroupChatEvent>(_onTogglePin);
    on<DeleteGroupConversationEvent>(_onDelete);
    on<ShowDeleteGroupDialogEvent>(_onShowDeleteDialog);
    on<AddGroupMembersEvent>(_onAddMembers);
    on<RemoveGroupMemberEvent>(_onRemoveMember);
    on<DisbandGroupEvent>(_onDisbandGroup);
  }

  Future<void> _onInit(
    InitGroupSettingEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    final currentUserId = DatabaseManager.currentUserId ?? '';
    emit(state.copyWith(
      status: GroupSettingStatus.loading,
      conversationId: event.conversationId,
      currentUserId: currentUserId,
    ));

    try {
      final chatList = await _conversationBusiness.getChatList();
      final conversation = chatList.where((c) => c.conversationId == event.conversationId).firstOrNull;

      if (conversation == null) {
        emit(state.copyWith(status: GroupSettingStatus.error, errorMessage: '会话不存在'));
        return;
      }

      final groupId = event.conversationId.replaceFirst('group_', '');
      final members = await _groupMemberBusiness.getGroupMembers(groupId);

      emit(state.copyWith(
        status: GroupSettingStatus.success,
        conversation: conversation,
        groupMembers: members,
      ));
    } catch (e) {
      emit(state.copyWith(status: GroupSettingStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onTogglePin(
    TogglePinGroupChatEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    if (state.isSaving || state.conversation == null) return;

    emit(state.copyWith(isSaving: true));
    try {
      final newIsPinned = !state.conversation!.isTop;
      await _conversationBusiness.togglePinChat(state.conversationId, newIsPinned);
      
      emit(state.copyWith(
        isSaving: false,
        conversation: state.conversation!.copyWith(isTop: newIsPinned),
      ));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteGroupConversationEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true, showDeleteDialog: false));
    try {
      await _conversationBusiness.deleteChat(state.conversationId);
      emit(state.copyWith(isSaving: false, status: GroupSettingStatus.deleted));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  void _onShowDeleteDialog(
    ShowDeleteGroupDialogEvent event,
    Emitter<GroupSettingState> emit,
  ) {
    emit(state.copyWith(showDeleteDialog: event.show));
  }

  Future<void> _onAddMembers(
    AddGroupMembersEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    if (state.isSaving || !state.isAdmin) return;
    
    emit(state.copyWith(isSaving: true));
    try {
      final groupId = state.conversationId.replaceFirst('group_', '');
      final response = await addGroupMemberApi(IGroupAddMembersReq(
        groupId: groupId, 
        userIds: event.userIds,
      ));
      
      if (response.code != 0) {
        throw Exception(response.msg);
      }
      
      // Reload members (WS will eventually trigger sync, but we reload here for immediate UI feedback)
      final members = await _groupMemberBusiness.getGroupMembers(groupId);
      emit(state.copyWith(isSaving: false, groupMembers: members));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRemoveMember(
    RemoveGroupMemberEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    if (state.isSaving || !state.isAdmin) return;
    if (event.userId == state.currentUserId) return;

    emit(state.copyWith(isSaving: true));
    try {
      final groupId = state.conversationId.replaceFirst('group_', '');
      final response = await removeGroupMemberApi(IGroupRemoveMembersReq(
        groupId: groupId, 
        userIds: [event.userId],
      ));

      if (response.code != 0) {
        throw Exception(response.msg);
      }
      
      // Reload members
      final members = await _groupMemberBusiness.getGroupMembers(groupId);
      emit(state.copyWith(isSaving: false, groupMembers: members));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDisbandGroup(
    DisbandGroupEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    emit(state.copyWith(isSaving: true));
    try {
      // TODO: Disband API (if separate from deleteConversation)
      emit(state.copyWith(isSaving: false, status: GroupSettingStatus.deleted));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }
}
