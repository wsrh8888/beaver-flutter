import 'package:equatable/equatable.dart';

abstract class PrivateSettingEvent extends Equatable {
  const PrivateSettingEvent();

  @override
  List<Object?> get props => [];
}

class InitPrivateSettingEvent extends PrivateSettingEvent {
  final String conversationId;
  const InitPrivateSettingEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class TogglePinPrivateChatEvent extends PrivateSettingEvent {
  const TogglePinPrivateChatEvent();
}

class ToggleMutePrivateChatEvent extends PrivateSettingEvent {
  const ToggleMutePrivateChatEvent();
}

class DeletePrivateChatEvent extends PrivateSettingEvent {
  const DeletePrivateChatEvent();
}

class ShowDeletePrivateChatDialogEvent extends PrivateSettingEvent {
  final bool show;
  const ShowDeletePrivateChatDialogEvent(this.show);

  @override
  List<Object?> get props => [show];
}

class ClearChatHistoryEvent extends PrivateSettingEvent {
  const ClearChatHistoryEvent();
}

class ShowClearHistoryDialogEvent extends PrivateSettingEvent {
  final bool show;
  const ShowClearHistoryDialogEvent(this.show);

  @override
  List<Object?> get props => [show];
}
