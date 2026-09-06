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
import 'package:permission_handler/permission_handler.dart';
import 'package:beaver/features/common/scan/bloc/event.dart';
import 'package:beaver/features/common/scan/bloc/state.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('scan');

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(const ScanState()) {
    on<CheckPermissionEvent>(_onCheckPermission);
    on<ScanResultEvent>(_onScanResult);
    on<ToggleTorchEvent>(_onToggleTorch);
    on<ResetScannerEvent>(_onResetScanner);
  }

  Future<void> _onCheckPermission(
    CheckPermissionEvent event,
    Emitter<ScanState> emit,
  ) async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      _logger.info({'text': '相机权限已授予，开始扫码'});
      emit(state.copyWith(status: ScanStatus.scanning));
    } else {
      final requestStatus = await Permission.camera.request();
      if (requestStatus.isGranted) {
        _logger.info({'text': '相机权限已申请授予，开始扫码'});
        emit(state.copyWith(status: ScanStatus.scanning));
      } else {
        _logger.warn({'text': '相机权限被拒绝，无法扫码'});
        emit(state.copyWith(status: ScanStatus.permissionDenied));
      }
    }
  }

  void _onScanResult(
    ScanResultEvent event,
    Emitter<ScanState> emit,
  ) {
    if (state.status == ScanStatus.success) return;
    _logger.info({'text': '扫码识别到内容', 'data': {'code': event.code}});
    emit(state.copyWith(status: ScanStatus.success, result: event.code));
  }

  void _onToggleTorch(
    ToggleTorchEvent event,
    Emitter<ScanState> emit,
  ) {
    emit(state.copyWith(isTorchOn: !state.isTorchOn));
  }

  void _onResetScanner(
    ResetScannerEvent event,
    Emitter<ScanState> emit,
  ) {
    emit(state.copyWith(status: ScanStatus.scanning, result: null));
  }
}
