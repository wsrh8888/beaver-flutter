abstract class GroupMemberEvent {
  const GroupMemberEvent();
}

class LoadGroupMembersEvent extends GroupMemberEvent {
  final String groupId;
  final String mode;

  const LoadGroupMembersEvent(this.groupId, this.mode);
}

class ToggleSelectEvent extends GroupMemberEvent {
  final String userId;

  const ToggleSelectEvent(this.userId);
}

class ConfirmAddEvent extends GroupMemberEvent {
  const ConfirmAddEvent();
}

class ConfirmRemoveEvent extends GroupMemberEvent {
  const ConfirmRemoveEvent();
}
