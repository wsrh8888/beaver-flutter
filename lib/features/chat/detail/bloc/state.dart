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

import 'package:equatable/equatable.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/types/business/chat.dart';

enum ChatStatus { initial, loading, success, error, multiSelect }
enum ComposerPanelType { none, emoji, package }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<MessageModel> messages;
  final ChatModel? conversation;
  final String? conversationId;
  final String? errorMessage;
  final bool isLoadingMore;
  final bool hasMore;
  final String draft;
  final ComposerPanelType activePanel;
  final bool isVoiceMode;
  final bool isSending;
  final Set<String> selectedMessageIds;
  final MessageModel? editingMessage;
  final MessageModel? replyingMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.conversation,
    this.conversationId,
    this.errorMessage,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.draft = '',
    this.activePanel = ComposerPanelType.none,
    this.isVoiceMode = false,
    this.isSending = false,
    this.selectedMessageIds = const {},
    this.editingMessage,
    this.replyingMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<MessageModel>? messages,
    dynamic conversation,
    String? conversationId,
    String? errorMessage,
    bool? isLoadingMore,
    bool? hasMore,
    String? draft,
    ComposerPanelType? activePanel,
    bool? isVoiceMode,
    bool? isSending,
    Set<String>? selectedMessageIds,
    MessageModel? editingMessage,
    MessageModel? replyingMessage,
    bool clearEditingMessage = false,
    bool clearReplyingMessage = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      conversation: conversation ?? this.conversation,
      conversationId: conversationId ?? this.conversationId,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      draft: draft ?? this.draft,
      activePanel: activePanel ?? this.activePanel,
      isVoiceMode: isVoiceMode ?? this.isVoiceMode,
      isSending: isSending ?? this.isSending,
      selectedMessageIds: selectedMessageIds ?? this.selectedMessageIds,
      editingMessage: clearEditingMessage
          ? null
          : (editingMessage ?? this.editingMessage),
      replyingMessage: clearReplyingMessage
          ? null
          : (replyingMessage ?? this.replyingMessage),
    );
  }

  @override
  List<Object?> get props => [
    status, messages, conversation, conversationId, errorMessage, 
    isLoadingMore, hasMore, draft, activePanel, isVoiceMode, isSending, selectedMessageIds,
    editingMessage, replyingMessage,
  ];
}
