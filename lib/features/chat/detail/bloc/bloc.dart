import 'dart:async';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/store/message/message.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:uuid/uuid.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageBusiness _messageBusiness;
  final MessageStore _messageStore;
  final ContactStore _contactStore;
  final String? _boundConversationId;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _contactSubscription;

  ChatBloc({
    String? conversationId,
    MessageBusiness? messageBusiness,
    MessageStore? messageStore,
    ContactStore? contactStore,
  })  : _boundConversationId = _normalizeConversationId(conversationId),
        _messageBusiness = messageBusiness ?? getIt<MessageBusiness>(),
        _messageStore = messageStore ?? getIt<MessageStore>(),
        _contactStore = contactStore ?? getIt<ContactStore>(),
        super(ChatState(conversationId: _normalizeConversationId(conversationId))) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<LoadMoreMessagesEvent>(_onLoadMore);
    on<SendMessageEvent>(_onSendMessage);
    on<UpdateDraftEvent>(_onUpdateDraft);
    on<ToggleComposerPanelEvent>(_onTogglePanel);
    on<ToggleVoiceModeEvent>(_onToggleVoiceMode);
    on<DismissComposerEvent>(_onDismissComposer);
    on<EnterMultiSelectEvent>(_onEnterMultiSelect);
    on<CancelMultiSelectEvent>(_onCancelMultiSelect);
    on<ToggleMessageSelectionEvent>(_onToggleSelection);
    on<MessageUpdatedEvent>(_onMessageUpdated);

    _messageSubscription = _messageStore.stream.listen((_) {
      if (state.conversationId != null) {
        // 收到新消息时，如果是当前会话，自动标为已读
        getIt<ConversationBusiness>().markAsRead(state.conversationId!);
        add(MessageUpdatedEvent(state.conversationId!));
      }
    });

    _contactSubscription = _contactStore.stream.listen((_) {
      if (state.conversationId != null) {
        add(MessageUpdatedEvent(state.conversationId!));
      }
    });
  }

  static String? _normalizeConversationId(String? conversationId) {
    if (conversationId == null || conversationId.isEmpty) return null;
    return conversationId;
  }

  String? _resolveConversationId([String? fallback]) {
    final fromState = state.conversationId;
    if (fromState != null && fromState.isNotEmpty) return fromState;
    if (fallback != null && fallback.isNotEmpty) return fallback;
    return _boundConversationId;
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _contactSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    final conversationId = _normalizeConversationId(event.conversationId);
    if (conversationId == null) {
      print('[ChatBloc] 加载失败: conversationId 为空');
      return;
    }
    final cachedMessages = _messageStore.state.chatHistory[conversationId];
    final hasCache = cachedMessages != null && cachedMessages.isNotEmpty;

    emit(state.copyWith(
      conversationId: conversationId,
      status: hasCache ? ChatStatus.success : ChatStatus.loading,
    ));

    if (hasCache) {
      _syncStoreToState(emit, conversationId);
    }

    await _messageStore.initConversation(conversationId);
    final conversation = await _messageBusiness.getConversation(conversationId);

    getIt<ConversationBusiness>().markAsRead(conversationId);

    _syncStoreToState(emit, conversationId, conversation: conversation);
  }

  void _onMessageUpdated(MessageUpdatedEvent event, Emitter<ChatState> emit) {
    if (event.conversationId == state.conversationId) {
      _syncStoreToState(emit, event.conversationId);
    }
  }

  void _syncStoreToState(Emitter<ChatState> emit, String conversationId, {dynamic conversation}) {
    final messages = _messageStore.state.chatHistory[conversationId] ?? [];
    final pagination = _messageStore.state.messagePagination[conversationId] ?? const MessagePagination();

    // 注入最新的联系人信息
    final enrichedMessages = messages.map((m) {
      final contact = _contactStore.getContact(m.userId);
      if (contact != null) {
        return m.copyWith(nickname: contact.nickname, avatar: contact.avatar);
      }
      // The provided snippet is syntactically incorrect in this context.
      // It appears to be a UI event handler, not valid within a map function.
      // To maintain syntactic correctness as per instructions, it cannot be inserted here as is.
      // Assuming the instruction intended to modify the `return m;` line,
      // but the provided snippet is not a valid replacement for a MessageModel.
      // Therefore, the original `return m;` is kept to preserve syntax.
      return m;
    }).toList();

    emit(state.copyWith(
      status: ChatStatus.success,
      conversationId: conversationId,
      messages: enrichedMessages,
      conversation: conversation ?? state.conversation,
      hasMore: pagination.hasMore,
      isLoadingMore: pagination.isLoadingMore,
    ));
  }

  Future<void> _onLoadMore(LoadMoreMessagesEvent event, Emitter<ChatState> emit) async {
    if (state.conversationId == null) return;
    await _messageStore.loadMore(state.conversationId!);
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final conversationId = _resolveConversationId(event.conversationId);
    if (conversationId == null) {
      print('[ChatBloc] 发送失败: conversationId 为空');
      return;
    }
    final msg = event.msg;
    
    final tempId = const Uuid().v4();
    final tempMsg = MessageModel(
      id: tempId,
      userId: 'me',
      conversationId: conversationId,
      msg: msg,
      createdAt: DateTime.now(),
      type: msg.type,
      status: MessageStatus.sending,
      isSent: true,
    );
    
    final chatType = conversationId.startsWith('group_') ? 'group' : 'private';
    final body = ChatMessageSendBody(
      conversationId: conversationId,
      messageId: tempId,
      msg: msg,
      chatType: chatType,
    );
    
    if (state.conversationId != conversationId) {
      emit(state.copyWith(conversationId: conversationId));
    }

    emit(state.copyWith(messages: [tempMsg, ...state.messages], draft: '', isSending: true));

    try {
      final realMsg = await _messageBusiness.sendMessage(body);
      _messageStore.addMessage(conversationId, realMsg);
      emit(state.copyWith(isSending: false));
    } catch (e) {
      final updatedMessages = state.messages.map((m) => m.id == tempId ? m.copyWith(status: MessageStatus.failed) : m).toList();
      emit(state.copyWith(messages: updatedMessages, isSending: false, errorMessage: 'Failed to send message'));
    }
  }

  void _onUpdateDraft(UpdateDraftEvent event, Emitter<ChatState> emit) => emit(state.copyWith(draft: event.draft));

  void _onTogglePanel(ToggleComposerPanelEvent event, Emitter<ChatState> emit) {
    if (state.activePanel == event.panelType) {
      emit(state.copyWith(activePanel: ComposerPanelType.none));
    } else {
      emit(state.copyWith(activePanel: event.panelType, isVoiceMode: false));
    }
  }

  void _onToggleVoiceMode(ToggleVoiceModeEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(isVoiceMode: !state.isVoiceMode, activePanel: ComposerPanelType.none));
  }

  void _onDismissComposer(DismissComposerEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(activePanel: ComposerPanelType.none));
  }

  void _onEnterMultiSelect(EnterMultiSelectEvent event, Emitter<ChatState> emit) {
    final selection = event.initialMessageId != null ? {event.initialMessageId!} : <String>{};
    emit(state.copyWith(status: ChatStatus.multiSelect, selectedMessageIds: selection));
  }

  void _onCancelMultiSelect(CancelMultiSelectEvent event, Emitter<ChatState> emit) => emit(state.copyWith(status: ChatStatus.success, selectedMessageIds: {}));

  void _onToggleSelection(ToggleMessageSelectionEvent event, Emitter<ChatState> emit) {
    final selection = Set<String>.from(state.selectedMessageIds);
    if (selection.contains(event.messageId)) {
      selection.remove(event.messageId);
    } else {
      selection.add(event.messageId);
    }
    emit(state.copyWith(selectedMessageIds: selection));
  }
}
