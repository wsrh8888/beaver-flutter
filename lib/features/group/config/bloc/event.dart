abstract class GroupConfigEvent {
  const GroupConfigEvent();
}

class LoadGroupInfoEvent extends GroupConfigEvent {
  final String groupId;

  const LoadGroupInfoEvent(this.groupId);
}

class OpenNameModalEvent extends GroupConfigEvent {
  const OpenNameModalEvent();
}

class CloseNameModalEvent extends GroupConfigEvent {
  const CloseNameModalEvent();
}

class UpdateGroupNameEvent extends GroupConfigEvent {
  final String name;

  const UpdateGroupNameEvent(this.name);
}

class SaveGroupNameEvent extends GroupConfigEvent {
  const SaveGroupNameEvent();
}

class NavigateToGroupMemberEvent extends GroupConfigEvent {
  final String mode;

  const NavigateToGroupMemberEvent(this.mode);
}

class ExitGroupEvent extends GroupConfigEvent {
  const ExitGroupEvent();
}
