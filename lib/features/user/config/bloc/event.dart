abstract class UserConfigEvent {
  const UserConfigEvent();
}

class LoadUserConfigEvent extends UserConfigEvent {
  final String userId;
  const LoadUserConfigEvent(this.userId);
}

class ToggleStickyEvent extends UserConfigEvent {
  final String userId;
  const ToggleStickyEvent(this.userId);
}

class ToggleMuteEvent extends UserConfigEvent {
  final String userId;
  const ToggleMuteEvent(this.userId);
}
