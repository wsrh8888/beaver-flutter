abstract class NewFriendsEvent {
  const NewFriendsEvent();
}

class LoadFriendRequestsEvent extends NewFriendsEvent {
  const LoadFriendRequestsEvent();
}

class SwitchTabEvent extends NewFriendsEvent {
  final String tab;

  const SwitchTabEvent(this.tab);
}

class AcceptRequestEvent extends NewFriendsEvent {
  final int id;

  const AcceptRequestEvent(this.id);
}

class RejectRequestEvent extends NewFriendsEvent {
  final int id;

  const RejectRequestEvent(this.id);
}
