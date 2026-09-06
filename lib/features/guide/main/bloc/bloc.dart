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
import 'package:beaver/features/guide/main/bloc/event.dart';
import 'package:beaver/features/guide/main/bloc/state.dart';
import 'package:beaver/features/guide/main/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('guide-main');

class GuideBloc extends Bloc<GuideEvent, GuideState> {
  final GuideRepository _repository;

  GuideBloc(this._repository) : super(const GuideState()) {
    on<LoadGuideConfigEvent>(_onLoadGuideConfig);
    on<NavigateToRegisterEvent>(_onNavigateToRegister);
    on<NavigateToLoginEvent>(_onNavigateToLogin);
  }

  Future<void> _onLoadGuideConfig(
    LoadGuideConfigEvent event,
    Emitter<GuideState> emit,
  ) async {
    emit(state.copyWith(status: GuideStatus.loading));
    _logger.info({'text': '加载引导页配置'});

    try {
      final guideConfig = await _repository.getGuideConfig();
      _logger.info({'text': '加载引导页配置成功'});
      emit(state.copyWith(
        status: GuideStatus.success,
        guideConfig: guideConfig,
      ));
    } catch (e) {
      _logger.error({'text': '加载引导页配置失败', 'data': {'error': e.toString()}});
      emit(state.copyWith(
        status: GuideStatus.error,
        errorMessage: '加载引导页配置失败 $e',
      ));
    }
  }

  Future<void> _onNavigateToRegister(
    NavigateToRegisterEvent event,
    Emitter<GuideState> emit,
  ) async {
    // 导航到注册页面
  }

  Future<void> _onNavigateToLogin(
    NavigateToLoginEvent event,
    Emitter<GuideState> emit,
  ) async {
    // 导航到登录页面
  }
}
