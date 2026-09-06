/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

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
import 'package:beaver/common/logger/index.dart';
import 'package:uuid/uuid.dart';

final _logger = Logger('chat-detail');

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
      _logger.error({'text': '加载会话消息失败: conversationId 为空'});
      return;
    }
    _logger.info({
      'text': '开始加载会话消息',
      'data': {'conversationId': conversationId},
    });
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
    _logger.info({
      'text': '会话消息加载完成',
      'data': {'conversationId': conversationId},
    });

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
      _logger.error({'text': '发送消息失败: conversationId 为空'});
      return;
    }
    _logger.info({
      'text': '开始发送消息',
      'data': {'conversationId': conversationId, 'type': event.msg.type.name},
    });

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
      _logger.info({
        'text': '消息发送成功',
        'data': {'conversationId': conversationId, 'messageId': realMsg.id},
      });
      _messageStore.addMessage(conversationId, realMsg);
      _syncStoreToState(emit, conversationId);
      emit(state.copyWith(isSending: false));
    } catch (e) {
      _logger.error({
        'text': '消息发送失败',
        'data': {'conversationId': conversationId, 'error': e.toString()},
      });
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

    _logger.info({
      'text': '开始重发消息',
      'data': {'conversationId': conversationId, 'messageId': event.messageId},
    });

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
      _logger.error({
        'text': '重发消息失败',
        'data': {'conversationId': conversationId, 'error': e.toString()},
      });
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
