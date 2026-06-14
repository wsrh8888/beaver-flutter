import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/api/update.dart';
import 'package:beaver/types/api/update.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/store/user/user.dart';
import 'package:beaver/features/setting/update/data/platform_info.dart';

class UpdateStoreState extends Equatable {
  final String? version;
  final IGetLatestVersionRes? latestVersion;
  final bool checked;

  const UpdateStoreState({
    this.version,
    this.latestVersion,
    this.checked = false,
  });

  UpdateStoreState copyWith({
    String? version,
    IGetLatestVersionRes? latestVersion,
    bool? checked,
  }) {
    return UpdateStoreState(
      version: version ?? this.version,
      latestVersion: latestVersion ?? this.latestVersion,
      checked: checked ?? this.checked,
    );
  }

  @override
  List<Object?> get props => [version, latestVersion, checked];
}

class UpdateStore extends Cubit<UpdateStoreState> {
  final UserStore _userStore;

  UpdateStore(this._userStore) : super(const UpdateStoreState());

  Future<void> init() async {
    if (state.checked) return;

    final platform = UpdatePlatformInfo.current();
    if (platform.platformId == 0) {
      emit(state.copyWith(checked: true));
      return;
    }

    final currentVersion = AppConfig.version;
    final userId = _userStore.state.currentUserId;

    await reportVersionApi(IReportVersionReq(
      userId: userId,
      deviceId: AppConfig.deviceId,
      version: currentVersion,
      appId: AppConfig.updateAppId,
      platformId: platform.platformId,
      archId: platform.archId,
    ));

    final response = await getLatestVersionApi(IGetLatestVersionReq(
      userId: userId,
      deviceId: AppConfig.deviceId,
      version: currentVersion,
      appId: AppConfig.updateAppId,
      platformId: platform.platformId,
      archId: platform.archId,
    ));

    if (response.code == 0 && response.result != null) {
      emit(state.copyWith(
        version: currentVersion,
        latestVersion: response.result!.hasUpdate ? response.result : null,
        checked: true,
      ));
      return;
    }

    emit(state.copyWith(version: currentVersion, checked: true));
  }
}
