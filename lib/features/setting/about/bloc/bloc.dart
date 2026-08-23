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
import 'package:beaver/features/setting/about/bloc/event.dart';
import 'package:beaver/features/setting/about/bloc/state.dart';
import 'package:beaver/features/setting/about/data/repositories/repository.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  final AboutRepository _repository;

  AboutBloc(this._repository) : super(const AboutState()) {
    on<LoadAppInfoEvent>(_onLoadAppInfo);
  }

  Future<void> _onLoadAppInfo(
    LoadAppInfoEvent event,
    Emitter<AboutState> emit,
  ) async {
    emit(state.copyWith(status: AboutStatus.loading));

    try {
      final appInfo = await _repository.getAppInfo();
      emit(state.copyWith(
        status: AboutStatus.success,
        appInfo: appInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AboutStatus.error,
        errorMessage: '加载应用信息失败: $e',
      ));
    }
  }
}

