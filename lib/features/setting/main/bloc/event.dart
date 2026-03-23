abstract class SettingMainEvent {
  const SettingMainEvent();
}

class LoadSettingItemsEvent extends SettingMainEvent {
  const LoadSettingItemsEvent();
}

class ShowLogoutDialogEvent extends SettingMainEvent {
  const ShowLogoutDialogEvent();
}

class HideLogoutDialogEvent extends SettingMainEvent {
  const HideLogoutDialogEvent();
}

class LogoutEvent extends SettingMainEvent {
  const LogoutEvent();
}
