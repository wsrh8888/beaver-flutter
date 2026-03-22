import 'package:beaver/types/business/message.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
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
  final String content;
  final MessageType type;

  const SendMessageEvent(this.content, this.type);

  @override
  List<Object?> get props => [content, type];
}

class UpdateMessageStatusEvent extends ChatEvent {
  final String messageId;
  final MessageStatus status;

  const UpdateMessageStatusEvent(this.messageId, this.status);

  @override
  List<Object?> get props => [messageId, status];
}

class MessageReceivedEvent extends ChatEvent {
  final String conversationId;

  const MessageReceivedEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class UpdateDraftEvent extends ChatEvent {
  final String draft;

  const UpdateDraftEvent(this.draft);

  @override
  List<Object?> get props => [draft];
}

enum ComposerPanelType {
  none,
  emoji,
  package,
}

class ToggleComposerPanelEvent extends ChatEvent {
  final ComposerPanelType panel;

  const ToggleComposerPanelEvent(this.panel);

  @override
  List<Object?> get props => [panel];
}

class ToolbarActionEvent extends ChatEvent {
  final ChatToolbarAction action;

  const ToolbarActionEvent(this.action);

  @override
  List<Object?> get props => [action];
}

enum ChatToolbarAction {
  image,
  camera,
  audio,
  emoji,
  package,
}
