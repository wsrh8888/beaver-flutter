import 'package:beaver/api/group.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/group_setting/bloc/event.dart';
import 'package:beaver/features/chat/group_setting/bloc/state.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/store/group/group_member.dart';
import 'package:beaver/store/message/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSettingBloc extends Bloc<GroupSettingEvent, GroupSettingState> {
  final _conversationBusiness = getIt<ConversationBusiness>();
  final _groupMemberStore = getIt<GroupMemberStore>();

  GroupSettingBloc() : super(const GroupSettingState()) {
    on<InitGroupSettingEvent>(_onInit);
    on<TogglePinGroupChatEvent>(_onTogglePin);
    on<ToggleMuteGroupChatEvent>(_onToggleMute);
    on<DeleteGroupConversationEvent>(_onDelete);
    on<ShowDeleteGroupDialogEvent>(_onShowDeleteDialog);
    on<AddGroupMembersEvent>(_onAddMembers);
    on<RemoveGroupMemberEvent>(_onRemoveMember);
    on<DisbandGroupEvent>(_onDisbandGroup);
    on<ClearGroupChatHistoryEvent>(_onClearHistory);
    on<ShowClearGroupHistoryDialogEvent>(_onShowClearDialog);
  }

  Future<void> _onInit(
    InitGroupSettingEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    final currentUserId = DatabaseManager.currentUserId ?? '';
    emit(
      state.copyWith(
        status: GroupSettingStatus.loading,
        conversationId: event.conversationId,
        currentUserId: currentUserId,
      ),
    );

    try {
      final chatList = await _conversationBusiness.getChatList();
      final conversation = chatList
          .where((c) => c.conversationId == event.conversationId)
          .firstOrNull;

      if (conversation == null) {
        emit(
          state.copyWith(
            status: GroupSettingStatus.error,
            errorMessage: '会话不存在',
          ),
        );
        return;
      }

      final groupId = event.conversationId.replaceFirst('group_', '');

      // 1. 初始化 Store (如果尚未加载)
      await _groupMemberStore.init(groupId);

      // 2. 从 Store 获取重组后的成员列表进行一次初始同步 (给 Bloc 内部逻辑用，如 isAdmin 判断)
      final members = _groupMemberStore.getMembersByGroupId(groupId);

      emit(
        state.copyWith(
          status: GroupSettingStatus.success,
          conversation: conversation,
          groupMembers: members,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GroupSettingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTogglePin(
    TogglePinGroupChatEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    if (state.conversation == null) return;

    final previousIsTop = state.conversation!.isTop;
    final newIsPinned = !previousIsTop;

    emit(
      state.copyWith(
        conversation: state.conversation!.copyWith(isTop: newIsPinned),
      ),
    );

    try {
      await _conversationBusiness.togglePinChat(
        state.conversationId,
        newIsPinned,
      );
    } catch (e) {
      emit(
        state.copyWith(
          conversation: state.conversation!.copyWith(isTop: previousIsTop),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleMute(
    ToggleMuteGroupChatEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    if (state.conversation == null) return;

    final previousIsMuted = state.conversation!.isMuted;
    final newIsMuted = !previousIsMuted;

    emit(
      state.copyWith(
        conversation: state.conversation!.copyWith(isMuted: newIsMuted),
      ),
    );

    try {
      await _conversationBusiness.toggleMuteChat(
        state.conversationId,
        newIsMuted,
      );
    } catch (e) {
      emit(
        state.copyWith(
          conversation: state.conversation!.copyWith(isMuted: previousIsMuted),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDelete(
    DeleteGroupConversationEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    if (state.isSaving || state.isGroupOwner) return;

    emit(state.copyWith(isSaving: true, showDeleteDialog: false));
    try {
      final groupId = state.conversationId.replaceFirst('group_', '');
      final response = await quitGroupApi(IGroupQuitReq(groupId: groupId));
      if (response.code != 0) {
        throw Exception(response.msg);
      }

      await _removeLocalConversation(emit);
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
      final response = await addGroupMemberApi(
        IGroupAddMembersReq(groupId: groupId, userIds: event.userIds),
      );

      if (response.code != 0) {
        throw Exception(response.msg);
      }

      // 实时更新 Store (对标 PC Pinia 流程)
      await _groupMemberStore.updateMembersByGroupIds([groupId]);
      final members = _groupMemberStore.getMembersByGroupId(groupId);

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
      final response = await removeGroupMemberApi(
        IGroupRemoveMembersReq(groupId: groupId, userIds: [event.userId]),
      );

      if (response.code != 0) {
        throw Exception(response.msg);
      }

      // 同步更新 Store
      await _groupMemberStore.updateMembersByGroupIds([groupId]);
      final members = _groupMemberStore.getMembersByGroupId(groupId);

      emit(state.copyWith(isSaving: false, groupMembers: members));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDisbandGroup(
    DisbandGroupEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    if (state.isSaving || !state.isGroupOwner) return;

    emit(state.copyWith(isSaving: true, showDeleteDialog: false));
    try {
      final groupId = state.conversationId.replaceFirst('group_', '');
      final response = await deleteGroupApi(IGroupDeleteReq(groupId: groupId));
      if (response.code != 0) {
        throw Exception(response.msg);
      }

      await _removeLocalConversation(emit);
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _removeLocalConversation(Emitter<GroupSettingState> emit) async {
    await _conversationBusiness.deleteChat(state.conversationId);
    _conversationBusiness.notifyConversationUpdate();
    emit(state.copyWith(isSaving: false, status: GroupSettingStatus.deleted));
  }

  Future<void> _onClearHistory(
    ClearGroupChatHistoryEvent event,
    Emitter<GroupSettingState> emit,
  ) async {
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true, showClearDialog: false));
    try {
      final conversationId = state.conversationId;

      // 1. 清除本地数据库和元数据 (Business 层)
      await getIt<MessageBusiness>().clearHistory(conversationId);

      // 2. 清除 Store 中的内存缓存
      getIt<MessageStore>().clearConversationMessages(conversationId);

      emit(state.copyWith(
        isSaving: false,
        status: GroupSettingStatus.historyCleared,
        conversation: state.conversation?.copyWith(msgPreview: ''),
      ));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  void _onShowClearDialog(
    ShowClearGroupHistoryDialogEvent event,
    Emitter<GroupSettingState> emit,
  ) {
    emit(state.copyWith(showClearDialog: event.show));
  }
}
