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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/api/oauth.dart';
import 'package:beaver/features/oauth/scan/bloc/event.dart';
import 'package:beaver/features/oauth/scan/bloc/state.dart';
import 'package:beaver/types/api/oauth.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('oauth-scan');

class OAuthScanConfirmBloc extends Bloc<OAuthScanConfirmEvent, OAuthScanConfirmState> {
  OAuthScanConfirmBloc() : super(const OAuthScanConfirmState()) {
    on<OAuthScanConfirmInitEvent>(_onInit);
    on<OAuthScanConfirmSubmitEvent>(_onSubmit);
    on<OAuthScanConfirmCancelEvent>(_onCancel);
  }

  Future<void> _onInit(
    OAuthScanConfirmInitEvent event,
    Emitter<OAuthScanConfirmState> emit,
  ) async {
    emit(state.copyWith(status: OAuthScanConfirmStatus.loading, sceneId: event.sceneId));
    _logger.info({'text': '初始化扫码确认', 'data': {'sceneId': event.sceneId}});

    final sceneRes = await getQrCodeSceneApi(event.sceneId);
    if (sceneRes.code != 0 || sceneRes.result == null) {
      _logger.warn({
        'text': '获取扫码会话失败',
        'data': {'sceneId': event.sceneId, 'code': sceneRes.code, 'msg': sceneRes.msg},
      });
      emit(state.copyWith(
        status: OAuthScanConfirmStatus.error,
        errorMessage: sceneRes.msg.isNotEmpty ? sceneRes.msg : '扫码会话无效',
      ));
      return;
    }

    final scene = sceneRes.result!;
    if (scene.status == 'expired' || scene.status == 'cancelled' || scene.status == 'confirmed') {
      _logger.warn({
        'text': '扫码会话已失效',
        'data': {'sceneId': event.sceneId, 'status': scene.status},
      });
      emit(state.copyWith(
        status: OAuthScanConfirmStatus.error,
        errorMessage: '二维码已失效，请重新扫码',
      ));
      return;
    }

    final scanRes = await scanQrCodeApi(IScanQrCodeReq(sceneId: event.sceneId));
    if (scanRes.code != 0) {
      _logger.warn({
        'text': '标记扫码失败',
        'data': {'sceneId': event.sceneId, 'code': scanRes.code, 'msg': scanRes.msg},
      });
      emit(state.copyWith(
        status: OAuthScanConfirmStatus.error,
        errorMessage: scanRes.msg.isNotEmpty ? scanRes.msg : '标记扫码失败',
      ));
      return;
    }

    _logger.info({
      'text': '扫码确认就绪',
      'data': {'sceneId': event.sceneId, 'appName': scene.appName},
    });
    emit(state.copyWith(
      status: OAuthScanConfirmStatus.ready,
      appName: scene.appName,
      appIcon: scene.appIcon,
      scopes: scene.scopes,
    ));
  }

  Future<void> _onSubmit(
    OAuthScanConfirmSubmitEvent event,
    Emitter<OAuthScanConfirmState> emit,
  ) async {
    if (state.sceneId.isEmpty) return;
    emit(state.copyWith(status: OAuthScanConfirmStatus.submitting));
    _logger.info({'text': '确认授权扫码登录', 'data': {'sceneId': state.sceneId}});

    final res = await confirmQrCodeApi(IConfirmQrCodeReq(sceneId: state.sceneId));
    if (res.code == 0) {
      _logger.info({'text': '扫码授权成功', 'data': {'sceneId': state.sceneId}});
      emit(state.copyWith(status: OAuthScanConfirmStatus.success));
      return;
    }

    _logger.warn({
      'text': '扫码授权失败',
      'data': {'sceneId': state.sceneId, 'code': res.code, 'msg': res.msg},
    });
    emit(state.copyWith(
      status: OAuthScanConfirmStatus.ready,
      errorMessage: res.msg.isNotEmpty ? res.msg : '授权失败',
    ));
  }

  Future<void> _onCancel(
    OAuthScanConfirmCancelEvent event,
    Emitter<OAuthScanConfirmState> emit,
  ) async {
    if (state.sceneId.isNotEmpty) {
      _logger.info({'text': '取消扫码授权', 'data': {'sceneId': state.sceneId}});
      await cancelQrCodeApi(ICancelQrCodeReq(sceneId: state.sceneId));
    }
  }
}
