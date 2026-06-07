import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/private_setting/bloc/event.dart';
import 'package:beaver/features/chat/private_setting/bloc/state.dart';
import 'package:beaver/store/message/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivateSettingBloc extends Bloc<PrivateSettingEvent, PrivateSettingState> {
  final _conversationBusiness = getIt<ConversationBusiness>();

  PrivateSettingBloc() : super(const PrivateSettingState()) {
    on<InitPrivateSettingEvent>(_onInit);
    on<TogglePinPrivateChatEvent>(_onTogglePin);
    on<DeletePrivateChatEvent>(_onDelete);
    on<ShowDeletePrivateChatDialogEvent>(_onShowDeleteDialog);
    on<ClearChatHistoryEvent>(_onClearHistory);
    on<ShowClearHistoryDialogEvent>(_onShowClearDialog);
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

  Future<void> _onClearHistory(
    ClearChatHistoryEvent event,
    Emitter<PrivateSettingState> emit,
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
        status: PrivateSettingStatus.historyCleared,
        conversation: state.conversation?.copyWith(msgPreview: ''),
      ));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  void _onShowClearDialog(
    ShowClearHistoryDialogEvent event,
    Emitter<PrivateSettingState> emit,
  ) {
    emit(state.copyWith(showClearDialog: event.show));
  }
}
