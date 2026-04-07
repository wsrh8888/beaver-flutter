import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/api/update.dart';
import 'package:beaver/types/api/update.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/store/user/user.dart';

class UpdateStoreState extends Equatable {
  final String? version;
  final GetLatestVersionRes? latestVersion;
  final bool checked;

  const UpdateStoreState({
    this.version,
    this.latestVersion,
    this.checked = false,
  });

  UpdateStoreState copyWith({
    String? version,
    GetLatestVersionRes? latestVersion,
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

    try {
      final currentVersion = AppConfig.version;
      final deviceId = AppConfig.deviceId;
      final userId = _userStore.state.currentUserId;

      // 1. 判定平台和架构 (根据 server API 定义)
      int platformId = 0;
      int archId = 0;
      if (Platform.isAndroid) {
        platformId = 4;
        archId = 6;
      } else if (Platform.isIOS) {
        platformId = 3;
        archId = 5;
      } else if (Platform.isWindows) {
        platformId = 1;
        archId = 1; // WinX64
      } else if (Platform.isMacOS) {
        platformId = 2;
        archId = 3; // MacIntel
      }

      // 2. 上报版本
      await reportVersionApi(ReportVersionReq(
        userId: userId,
        deviceId: deviceId,
        version: currentVersion,
        appId: 'beaver-flutter',
        platformId: platformId,
        archId: archId,
      ));

      // 3. 检查更新
      final response = await getLatestVersionApi(GetLatestVersionReq(
        userId: userId,
        deviceId: deviceId,
        version: currentVersion,
        appId: 'beaver-flutter',
        platformId: platformId,
        archId: archId,
      ));

      if (response.code == 0 && response.result != null) {
        emit(state.copyWith(
          version: currentVersion,
          latestVersion: response.result!.hasUpdate ? response.result : null,
          checked: true,
        ));
      }
    } catch (e) {
      // 容错处理，不阻塞主流程
      emit(state.copyWith(checked: true));
    }
  }
}
