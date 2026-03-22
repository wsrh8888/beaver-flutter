import 'dart:async';

import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _messageBusiness = getIt<MessageBusiness>();
  StreamSubscription<List<MessageModel>>? _messageSubscription;
  final _uuid = const Uuid();

  static const int _pageSize = 30;

  ChatBloc() : super(const ChatState()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<LoadMoreMessagesEvent>(_onLoadMoreMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<UpdateMessageStatusEvent>(_onUpdateMessageStatus);
    on<UpdateDraftEvent>(_onUpdateDraft);
    on<ToggleComposerPanelEvent>(_onToggleComposerPanel);
    on<ToolbarActionEvent>(_onToolbarAction);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ChatStatus.loading,
        conversationId: event.conversationId,
        activePanel: ComposerPanelType.none,
        clearError: true,
      ),
    );

    try {
      final conversationData = await _messageBusiness.getConversation(event.conversationId);
      final messages = await _messageBusiness.getMessages(
        event.conversationId,
        limit: _pageSize,
        offset: 0,
      );

      await _messageSubscription?.cancel();
      _messageSubscription = _messageBusiness.watchMessages(event.conversationId).listen(
        (incomingMessages) {
          if (incomingMessages.isNotEmpty) {
            add(MessageReceivedEvent(event.conversationId));
          }
        },
      );

      emit(
        state.copyWith(
          status: ChatStatus.success,
          conversation: conversationData,
          messages: _sortByTime(messages),
          hasMore: messages.length >= _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMoreMessages(
    LoadMoreMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationId == null || state.isLoadingMore || !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final nextBatch = await _messageBusiness.getMessages(
        state.conversationId!,
        limit: _pageSize,
        offset: state.messages.length,
      );
      final merged = _mergeMessages(nextBatch, state.messages);
      emit(
        state.copyWith(
          messages: _sortByTime(merged),
          hasMore: nextBatch.length >= _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          errorMessage: e.toString(),
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationId == null) {
      return;
    }

    final tempMessageId = _uuid.v4();
    final tempMessage = MessageModel(
      id: tempMessageId,
      conversationId: state.conversationId!,
      userId: 'me', // TODO: Get current user ID from UserStore
      content: event.content,
      type: event.type,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
      isSent: true,
    );

    final optimisticMessages = List<MessageModel>.from(state.messages)..add(tempMessage);
    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: _sortByTime(optimisticMessages),
        draft: '',
        activePanel: ComposerPanelType.none,
        isSending: true,
        clearError: true,
      ),
    );

    try {
      final sentMessage = await _messageBusiness.sendMessage(
        state.conversationId!,
        event.content,
        event.type,
      );

      final nextMessages = state.messages
          .where((message) => message.id != tempMessageId)
          .toList()
        ..add(sentMessage);

      emit(
        state.copyWith(
          status: ChatStatus.success,
          messages: _sortByTime(nextMessages),
          isSending: false,
          clearError: true,
        ),
      );
    } catch (e) {
      final failedMessages = state.messages.map((message) {
        if (message.id == tempMessageId) {
          return message.copyWith(status: MessageStatus.failed);
        }
        return message;
      }).toList();

      emit(
        state.copyWith(
          status: ChatStatus.error,
          messages: failedMessages,
          isSending: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (event.conversationId != state.conversationId) {
      return;
    }

    final messages = await _messageBusiness.getMessages(event.conversationId);
    final merged = _mergeMessages(state.messages, messages);
    emit(state.copyWith(messages: _sortByTime(merged), clearError: true));
  }

  Future<void> _onUpdateMessageStatus(
    UpdateMessageStatusEvent event,
    Emitter<ChatState> emit,
  ) async {
    final messages = state.messages.map((message) {
      if (message.id == event.messageId) {
        return message.copyWith(status: event.status);
      }
      return message;
    }).toList();

    emit(state.copyWith(messages: messages));
    await _messageBusiness.updateMessageStatus(event.messageId, event.status);
  }

  void _onUpdateDraft(UpdateDraftEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(draft: event.draft));
  }

  void _onToggleComposerPanel(
    ToggleComposerPanelEvent event,
    Emitter<ChatState> emit,
  ) {
    final nextPanel = state.activePanel == event.panel
        ? ComposerPanelType.none
        : event.panel;
    emit(state.copyWith(activePanel: nextPanel));
  }

  void _onToolbarAction(ToolbarActionEvent event, Emitter<ChatState> emit) {
    if (event.action == ChatToolbarAction.emoji) {
      add(const ToggleComposerPanelEvent(ComposerPanelType.emoji));
      return;
    }

    if (event.action == ChatToolbarAction.package) {
      add(const ToggleComposerPanelEvent(ComposerPanelType.package));
    }
  }

  List<MessageModel> _sortByTime(List<MessageModel> messages) {
    final sorted = List<MessageModel>.from(messages);
    sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return sorted;
  }

  List<MessageModel> _mergeMessages(
    List<MessageModel> first,
    List<MessageModel> second,
  ) {
    final byId = <String, MessageModel>{};
    for (final message in [...first, ...second]) {
      byId[message.id] = message;
    }
    return byId.values.toList();
  }

  @override
  Future<void> close() async {
    await _messageSubscription?.cancel();
    return super.close();
  }
}

