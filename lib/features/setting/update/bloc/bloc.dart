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

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/setting/update/bloc/event.dart';
import 'package:beaver/features/setting/update/bloc/state.dart';
import 'package:beaver/features/setting/update/data/repositories/repository.dart';
import 'package:beaver/common/config/config.dart';
import 'package:ota_update/ota_update.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final UpdateRepository _repository;

  UpdateBloc(this._repository)
      : super(UpdateState(currentVersion: AppConfig.version)) {
    on<CheckUpdateEvent>(_onCheckUpdate);
    on<OpenUpdateModalEvent>(_onOpenUpdateModal);
    on<CloseUpdateModalEvent>(_onCloseUpdateModal);
    on<DownloadUpdateEvent>(_onDownloadUpdate);
    on<UpdateProgressEvent>(_onUpdateProgress);
  }

  void _onOpenUpdateModal(
    OpenUpdateModalEvent event,
    Emitter<UpdateState> emit,
  ) {
    add(const CheckUpdateEvent());
  }

  Future<void> _onCheckUpdate(
    CheckUpdateEvent event,
    Emitter<UpdateState> emit,
  ) async {
    emit(state.copyWith(
      status: UpdateStatus.loading,
      currentVersion: AppConfig.version,
      showUpdateModal: false,
    ));

    final result = await _repository.checkUpdate();
    if (!result.isSuccess) {
      emit(state.copyWith(
        status: UpdateStatus.error,
        errorMessage: result.errorMessage,
        showUpdateModal: true,
      ));
      return;
    }

    emit(state.copyWith(
      status: UpdateStatus.success,
      updateInfo: result.updateInfo,
      showUpdateModal: true,
    ));
  }

  void _onCloseUpdateModal(
    CloseUpdateModalEvent event,
    Emitter<UpdateState> emit,
  ) {
    emit(state.copyWith(showUpdateModal: false));
  }

  Future<void> _onDownloadUpdate(
    DownloadUpdateEvent event,
    Emitter<UpdateState> emit,
  ) async {
    final updateInfo = state.updateInfo;
    if (updateInfo == null || updateInfo.latestVersion == null) return;
    final downloadUrl = updateInfo.latestVersion!.downloadUrl;

    if (Platform.isAndroid) {
      emit(state.copyWith(
        updateInfo: updateInfo.copyWith(isDownloading: true, downloadProgress: 0),
      ));

      OtaUpdate().execute(downloadUrl).listen((OtaEvent event) {
        if (event.status == OtaStatus.DOWNLOADING) {
          final progress = int.tryParse(event.value ?? '0') ?? 0;
          add(UpdateProgressEvent(progress));
        } else if (event.status == OtaStatus.INSTALLING) {
          add(const UpdateProgressEvent(100));
        } else if (event.status == OtaStatus.DOWNLOAD_ERROR ||
            event.status == OtaStatus.INTERNAL_ERROR ||
            event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
          add(const UpdateProgressEvent(-1));
        }
      });
      return;
    }

    if (Platform.isIOS) {
      final url = Uri.parse(downloadUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _onUpdateProgress(
    UpdateProgressEvent event,
    Emitter<UpdateState> emit,
  ) {
    if (event.progress < 0) {
      emit(state.copyWith(
        status: UpdateStatus.error,
        errorMessage: '下载失败，请稍后重试',
        updateInfo: state.updateInfo?.copyWith(isDownloading: false),
      ));
      return;
    }

    if (state.updateInfo != null) {
      emit(state.copyWith(
        updateInfo: state.updateInfo!.copyWith(
          downloadProgress: event.progress,
          isDownloading: event.progress < 100,
        ),
      ));
    }
  }
}
