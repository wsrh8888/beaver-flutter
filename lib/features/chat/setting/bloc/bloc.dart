import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/setting/bloc/event.dart';
import 'package:beaver/features/chat/setting/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatSettingBloc extends Bloc<ChatSettingEvent, ChatSettingState> {
  final _conversationBusiness = getIt<ConversationBusiness>();

  ChatSettingBloc() : super(const ChatSettingState()) {
    on<InitChatSettingEvent>(_onInit);
    on<TogglePinChatEvent>(_onTogglePin);
    on<DeleteConversationEvent>(_onDelete);
    on<ShowDeleteDialogEvent>(_onShowDeleteDialog);
  }

  Future<void> _onInit(
    InitChatSettingEvent event,
    Emitter<ChatSettingState> emit,
  ) async {
    emit(state.copyWith(status: ChatSettingStatus.loading, conversationId: event.conversationId));

    try {
      final chatList = await _conversationBusiness.getChatList();
      final conversation = chatList.where((c) => c.conversationId == event.conversationId).firstOrNull;

      if (conversation == null) {
        emit(state.copyWith(status: ChatSettingStatus.error, errorMessage: '会话不存在'));
        return;
      }

      emit(state.copyWith(status: ChatSettingStatus.success, conversation: conversation));
    } catch (e) {
      emit(state.copyWith(status: ChatSettingStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onTogglePin(
    TogglePinChatEvent event,
    Emitter<ChatSettingState> emit,
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
    DeleteConversationEvent event,
    Emitter<ChatSettingState> emit,
  ) async {
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true, showDeleteDialog: false));
    try {
      await _conversationBusiness.deleteChat(state.conversationId);
      emit(state.copyWith(isSaving: false, status: ChatSettingStatus.deleted));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  void _onShowDeleteDialog(
    ShowDeleteDialogEvent event,
    Emitter<ChatSettingState> emit,
  ) {
    emit(state.copyWith(showDeleteDialog: event.show));
  }
}
