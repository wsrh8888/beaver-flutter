import 'package:beaver/features/setting/main/data/models/setting_item.dart';

enum SettingMainStatus { initial, loading, success, error }

class SettingMainState {
  final SettingMainStatus status;
  final List<SettingItem> settingItems;
  final String? errorMessage;
  final bool showLogoutDialog;

  const SettingMainState({
    this.status = SettingMainStatus.initial,
    this.settingItems = const [],
    this.errorMessage,
    this.showLogoutDialog = false,
  });

  SettingMainState copyWith({
    SettingMainStatus? status,
    List<SettingItem>? settingItems,
    String? errorMessage,
    bool? showLogoutDialog,
  }) {
    return SettingMainState(
      status: status ?? this.status,
      settingItems: settingItems ?? this.settingItems,
      errorMessage: errorMessage ?? this.errorMessage,
      showLogoutDialog: showLogoutDialog ?? this.showLogoutDialog,
    );
  }
}
