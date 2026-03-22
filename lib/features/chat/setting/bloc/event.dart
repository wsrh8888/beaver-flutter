import 'package:equatable/equatable.dart';

abstract class ChatSettingEvent extends Equatable {
  const ChatSettingEvent();

  @override
  List<Object?> get props => [];
}

class InitChatSettingEvent extends ChatSettingEvent {
  final String conversationId;

  const InitChatSettingEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class TogglePinChatEvent extends ChatSettingEvent {
  const TogglePinChatEvent();
}

class DeleteConversationEvent extends ChatSettingEvent {
  const DeleteConversationEvent();
}

class ShowDeleteDialogEvent extends ChatSettingEvent {
  final bool show;

  const ShowDeleteDialogEvent(this.show);

  @override
  List<Object?> get props => [show];
}
