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
