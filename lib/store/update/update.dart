/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/api/update.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/types/api/update.dart';
import 'package:beaver/store/user/user.dart';
import 'package:beaver/features/setting/update/data/platform_info.dart';

final _logger = Logger('store-update');

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
    if (state.checked) {
      _logger.info({'text': '版本检查已完成，跳过', 'data': {}});
      return;
    }

    final platform = UpdatePlatformInfo.current();
    if (platform.platformId == 0) {
      _logger.warn({'text': '无法识别当前平台，跳过版本检查', 'data': {}});
      emit(state.copyWith(checked: true));
      return;
    }

    final currentVersion = AppConfig.version;
    final userId = _userStore.state.currentUserId;
    _logger.info({'text': '开始检查版本更新', 'data': {'currentVersion': currentVersion, 'platformId': platform.platformId}});

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
      _logger.info({'text': '版本检查完成', 'data': {'hasUpdate': response.result!.hasUpdate}});
      return;
    }

    _logger.warn({'text': '获取最新版本失败', 'data': {'code': response.code, 'msg': response.msg}});
    emit(state.copyWith(version: currentVersion, checked: true));
  }
}
