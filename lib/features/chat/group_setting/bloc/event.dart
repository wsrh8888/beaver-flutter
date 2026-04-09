import 'package:equatable/equatable.dart';

abstract class GroupSettingEvent extends Equatable {
  const GroupSettingEvent();

  @override
  List<Object?> get props => [];
}

class InitGroupSettingEvent extends GroupSettingEvent {
  final String conversationId;
  const InitGroupSettingEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class TogglePinGroupChatEvent extends GroupSettingEvent {
  const TogglePinGroupChatEvent();
}

class DeleteGroupConversationEvent extends GroupSettingEvent {
  const DeleteGroupConversationEvent();
}

class ShowDeleteGroupDialogEvent extends GroupSettingEvent {
  final bool show;
  const ShowDeleteGroupDialogEvent(this.show);

  @override
  List<Object?> get props => [show];
}

class AddGroupMembersEvent extends GroupSettingEvent {
  final List<String> userIds;
  const AddGroupMembersEvent(this.userIds);

  @override
  List<Object?> get props => [userIds];
}

class RemoveGroupMemberEvent extends GroupSettingEvent {
  final String userId;
  const RemoveGroupMemberEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DisbandGroupEvent extends GroupSettingEvent {
  const DisbandGroupEvent();
}
