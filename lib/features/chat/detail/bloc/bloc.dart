import 'dart:async';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/store/message/message.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/user/user.dart';
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
    on<StartEditMessageEvent>(_onStartEdit);
    on<CancelEditMessageEvent>(_onCancelEdit);
    on<SubmitEditMessageEvent>(_onSubmitEdit);
    on<StartReplyMessageEvent>(_onStartReply);
    on<CancelReplyMessageEvent>(_onCancelReply);
    on<RetrySendMessageEvent>(_onRetrySend);
    on<DeleteSelectedMessagesEvent>(_onDeleteSelected);

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

    final currentUserId = getIt<UserStore>().state.currentUserId;
    var outbound = event.msg;
    final replyingTo = state.replyingMessage;
    if (replyingTo != null) {
      outbound = MessageContentModel(
        type: MessageType.reply,
        replyMsg: ReplyMsg(
          originMsgId: replyingTo.id,
          originMsg: replyingTo.msg,
          replyMsg: event.msg,
        ),
      );
    }

    final tempId = const Uuid().v4();
    final tempMsg = MessageModel(
      id: tempId,
      userId: currentUserId,
      conversationId: conversationId,
      msg: outbound,
      createdAt: DateTime.now(),
      type: outbound.type,
      status: MessageStatus.sending,
      isSent: true,
    );
    
    final chatType = conversationId.startsWith('group_') ? 'group' : 'private';
    final body = ChatMessageSendBody(
      conversationId: conversationId,
      messageId: tempId,
      msg: outbound,
      chatType: chatType,
    );
    
    if (state.conversationId != conversationId) {
      emit(state.copyWith(conversationId: conversationId));
    }

    emit(state.copyWith(
      messages: [tempMsg, ...state.messages],
      draft: '',
      isSending: true,
      clearReplyingMessage: true,
    ));
    final pendingMessages = [tempMsg, ...state.messages];

    try {
      final realMsg = await _messageBusiness.sendMessage(body);
      _messageStore.addMessage(conversationId, realMsg);
      _syncStoreToState(emit, conversationId);
      emit(state.copyWith(isSending: false));
    } catch (e) {
      final failedMsg = tempMsg.copyWith(status: MessageStatus.failed);
      _messageStore.addMessage(conversationId, failedMsg);
      emit(state.copyWith(
        messages: pendingMessages
            .map((m) => m.id == tempId ? failedMsg : m)
            .toList(),
        isSending: false,
        errorMessage: '消息发送失败',
      ));
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

  void _onStartEdit(StartEditMessageEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      editingMessage: event.message,
      draft: event.message.content,
      activePanel: ComposerPanelType.none,
      isVoiceMode: false,
      clearReplyingMessage: true,
    ));
  }

  void _onCancelEdit(CancelEditMessageEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(draft: '', clearEditingMessage: true));
  }

  Future<void> _onSubmitEdit(
    SubmitEditMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final editing = state.editingMessage;
    if (editing == null) return;

    final content = event.content.trim();
    if (content.isEmpty) return;

    emit(state.copyWith(isSending: true));
    final err = await _messageBusiness.editMessage(
      editing.id,
      editing.conversationId,
      content,
    );
    if (err != null) {
      emit(state.copyWith(isSending: false, errorMessage: err));
      return;
    }

    _syncStoreToState(emit, editing.conversationId);
    emit(state.copyWith(
      isSending: false,
      draft: '',
      clearEditingMessage: true,
    ));
  }

  void _onStartReply(StartReplyMessageEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      replyingMessage: event.message,
      activePanel: ComposerPanelType.none,
      isVoiceMode: false,
      clearEditingMessage: true,
    ));
  }

  void _onCancelReply(CancelReplyMessageEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(clearReplyingMessage: true));
  }

  Future<void> _onRetrySend(
    RetrySendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final conversationId = state.conversationId;
    if (conversationId == null) return;

    final message = state.messages
        .where((m) => m.id == event.messageId)
        .firstOrNull;
    if (message == null || message.status != MessageStatus.failed) return;

    final chatType = conversationId.startsWith('group_') ? 'group' : 'private';
    final body = ChatMessageSendBody(
      conversationId: conversationId,
      messageId: message.id,
      msg: message.msg,
      chatType: chatType,
    );

    final sendingMsg = message.copyWith(status: MessageStatus.sending);
    _messageStore.addMessage(conversationId, sendingMsg);
    emit(state.copyWith(
      messages: state.messages
          .map((m) => m.id == message.id ? sendingMsg : m)
          .toList(),
      isSending: true,
    ));

    try {
      final realMsg = await _messageBusiness.sendMessage(body);
      _messageStore.addMessage(conversationId, realMsg);
      _syncStoreToState(emit, conversationId);
      emit(state.copyWith(isSending: false));
    } catch (e) {
      final failedMsg = message.copyWith(status: MessageStatus.failed);
      _messageStore.addMessage(conversationId, failedMsg);
      _syncStoreToState(emit, conversationId);
      emit(state.copyWith(isSending: false, errorMessage: '消息发送失败'));
    }
  }

  Future<void> _onDeleteSelected(
    DeleteSelectedMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    final conversationId = state.conversationId;
    if (conversationId == null || state.selectedMessageIds.isEmpty) return;

    final ids = state.selectedMessageIds.toList();
    for (final messageId in ids) {
      await _messageBusiness.deleteMessage(messageId, conversationId);
    }

    _syncStoreToState(emit, conversationId);
    emit(state.copyWith(status: ChatStatus.success, selectedMessageIds: {}));
  }
}
