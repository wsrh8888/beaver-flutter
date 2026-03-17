abstract class UserConfigEvent {
  const UserConfigEvent();
}

class LoadFriendInfoEvent extends UserConfigEvent {
  final String conversationId;
  const LoadFriendInfoEvent(this.conversationId);
}

class ToggleTopChatEvent extends UserConfigEvent {
  const ToggleTopChatEvent();
}

class ShowDeleteModalEvent extends UserConfigEvent {
  const ShowDeleteModalEvent();
}

class HideDeleteModalEvent extends UserConfigEvent {
  const HideDeleteModalEvent();
}

class ConfirmDeleteEvent extends UserConfigEvent {
  const ConfirmDeleteEvent();
}
