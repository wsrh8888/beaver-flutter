import 'package:beaver/features/setting/main/data/models/setting_item.dart';

enum SettingStatus { initial, loading, success, error }

class SettingState {
  final SettingStatus status;
  final List<SettingItem> settingItems;
  final String? errorMessage;
  final bool showLogoutDialog;

  const SettingState({
    this.status = SettingStatus.initial,
    this.settingItems = const [],
    this.errorMessage,
    this.showLogoutDialog = false,
  });

  SettingState copyWith({
    SettingStatus? status,
    List<SettingItem>? settingItems,
    String? errorMessage,
    bool? showLogoutDialog,
  }) {
    return SettingState(
      status: status ?? this.status,
      settingItems: settingItems ?? this.settingItems,
      errorMessage: errorMessage ?? this.errorMessage,
      showLogoutDialog: showLogoutDialog ?? this.showLogoutDialog,
    );
  }
}

