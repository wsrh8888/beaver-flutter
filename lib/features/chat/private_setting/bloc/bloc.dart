import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/private_setting/bloc/event.dart';
import 'package:beaver/features/chat/private_setting/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivateSettingBloc extends Bloc<PrivateSettingEvent, PrivateSettingState> {
  final _conversationBusiness = getIt<ConversationBusiness>();

  PrivateSettingBloc() : super(const PrivateSettingState()) {
    on<InitPrivateSettingEvent>(_onInit);
    on<TogglePinPrivateChatEvent>(_onTogglePin);
    on<DeletePrivateChatEvent>(_onDelete);
    on<ShowDeletePrivateChatDialogEvent>(_onShowDeleteDialog);
  }

  Future<void> _onInit(
    InitPrivateSettingEvent event,
    Emitter<PrivateSettingState> emit,
  ) async {
    emit(state.copyWith(status: PrivateSettingStatus.loading, conversationId: event.conversationId));

    try {
      final chatList = await _conversationBusiness.getChatList();
      final conversation = chatList.where((c) => c.conversationId == event.conversationId).firstOrNull;

      if (conversation == null) {
        emit(state.copyWith(status: PrivateSettingStatus.error, errorMessage: '会话不存在'));
        return;
      }

      emit(state.copyWith(status: PrivateSettingStatus.success, conversation: conversation));
    } catch (e) {
      emit(state.copyWith(status: PrivateSettingStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onTogglePin(
    TogglePinPrivateChatEvent event,
    Emitter<PrivateSettingState> emit,
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
    DeletePrivateChatEvent event,
    Emitter<PrivateSettingState> emit,
  ) async {
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true, showDeleteDialog: false));
    try {
      await _conversationBusiness.deleteChat(state.conversationId);
      emit(state.copyWith(isSaving: false, status: PrivateSettingStatus.deleted));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  void _onShowDeleteDialog(
    ShowDeletePrivateChatDialogEvent event,
    Emitter<PrivateSettingState> emit,
  ) {
    emit(state.copyWith(showDeleteDialog: event.show));
  }
}
