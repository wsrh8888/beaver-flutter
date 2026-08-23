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
import 'package:beaver/features/user/qrcode/bloc/event.dart';
import 'package:beaver/features/user/qrcode/bloc/state.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/features/user/qrcode/data/models/qrcode.dart';
import 'package:beaver/di/injection.dart';

class QrcodeBloc extends Bloc<QrcodeEvent, QrcodeState> {
  final UserBusiness _userBusiness = getIt<UserBusiness>();

  QrcodeBloc() : super(const QrcodeState()) {
    on<LoadQrCodeEvent>(_onLoadQrCode);
    on<SaveQrCodeEvent>(_onSaveQrCode);
  }

  Future<void> _onLoadQrCode(
    LoadQrCodeEvent event,
    Emitter<QrcodeState> emit,
  ) async {
    emit(state.copyWith(status: QrcodeStatus.loading));

    try {
      final userInfo = await _userBusiness.getMyUserInfo();
      emit(
        state.copyWith(
          status: QrcodeStatus.success,
          qrCodeData: QrCodeData(
            userId: userInfo.userId,
            nickname: userInfo.nickname,
            fileName: userInfo.avatar ?? '',
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: QrcodeStatus.error, errorMessage: '加载二维码失败 $e'),
      );
    }
  }

  Future<void> _onSaveQrCode(
    SaveQrCodeEvent event,
    Emitter<QrcodeState> emit,
  ) async {
    // 保存逻辑在页面处理，Bloc 仅用于状态
    emit(state.copyWith(errorMessage: '正在保存到相册...'));
  }
}
