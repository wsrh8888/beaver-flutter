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

import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/types/business/message.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class MessageUpdatedEvent extends ChatEvent {
  final String conversationId;
  const MessageUpdatedEvent(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class LoadMessagesEvent extends ChatEvent {
  final String conversationId;
  const LoadMessagesEvent(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class LoadMoreMessagesEvent extends ChatEvent {
  const LoadMoreMessagesEvent();
}

class SendMessageEvent extends ChatEvent {
  final MessageContentModel msg;
  final String? conversationId;
  const SendMessageEvent(this.msg, {this.conversationId});
  @override
  List<Object?> get props => [msg, conversationId];
}

class UpdateDraftEvent extends ChatEvent {
  final String draft;
  const UpdateDraftEvent(this.draft);
  @override
  List<Object?> get props => [draft];
}

class ToggleComposerPanelEvent extends ChatEvent {
  final ComposerPanelType panelType;
  const ToggleComposerPanelEvent(this.panelType);
  @override
  List<Object?> get props => [panelType];
}

class ToggleVoiceModeEvent extends ChatEvent {
  const ToggleVoiceModeEvent();
}

class DismissComposerEvent extends ChatEvent {
  const DismissComposerEvent();
}

class EnterMultiSelectEvent extends ChatEvent {
  final String? initialMessageId;
  const EnterMultiSelectEvent({this.initialMessageId});
  @override
  List<Object?> get props => [initialMessageId];
}

class CancelMultiSelectEvent extends ChatEvent {
  const CancelMultiSelectEvent();
}

class ToggleMessageSelectionEvent extends ChatEvent {
  final String messageId;
  const ToggleMessageSelectionEvent(this.messageId);
  @override
  List<Object?> get props => [messageId];
}

class StartEditMessageEvent extends ChatEvent {
  final MessageModel message;
  const StartEditMessageEvent(this.message);
  @override
  List<Object?> get props => [message];
}

class CancelEditMessageEvent extends ChatEvent {
  const CancelEditMessageEvent();
}

class SubmitEditMessageEvent extends ChatEvent {
  final String content;
  const SubmitEditMessageEvent(this.content);
  @override
  List<Object?> get props => [content];
}

class StartReplyMessageEvent extends ChatEvent {
  final MessageModel message;
  const StartReplyMessageEvent(this.message);
  @override
  List<Object?> get props => [message];
}

class CancelReplyMessageEvent extends ChatEvent {
  const CancelReplyMessageEvent();
}

class RetrySendMessageEvent extends ChatEvent {
  final String messageId;
  const RetrySendMessageEvent(this.messageId);
  @override
  List<Object?> get props => [messageId];
}

class DeleteSelectedMessagesEvent extends ChatEvent {
  const DeleteSelectedMessagesEvent();
}
