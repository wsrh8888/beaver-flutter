abstract class SettingEvent {
  const SettingEvent();
}

class LoadSettingItemsEvent extends SettingEvent {
  const LoadSettingItemsEvent();
}

class ShowLogoutDialogEvent extends SettingEvent {
  const ShowLogoutDialogEvent();
}

class HideLogoutDialogEvent extends SettingEvent {
  const HideLogoutDialogEvent();
}

class LogoutEvent extends SettingEvent {
  const LogoutEvent();
}
