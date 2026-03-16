abstract class GroupListEvent {
  const GroupListEvent();
}

class LoadGroupListEvent extends GroupListEvent {
  const LoadGroupListEvent();
}

class SelectGroupEvent extends GroupListEvent {
  final String conversationId;

  const SelectGroupEvent(this.conversationId);
}

class CreateGroupEvent extends GroupListEvent {
  const CreateGroupEvent();
}
