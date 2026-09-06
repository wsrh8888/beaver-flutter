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
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/features/setting/disclaimer/bloc/event.dart';
import 'package:beaver/features/setting/disclaimer/bloc/state.dart';
import 'package:beaver/features/setting/disclaimer/data/repositories/repository.dart';

final _logger = Logger('setting-disclaimer');

class DisclaimerBloc extends Bloc<DisclaimerEvent, DisclaimerState> {
  final DisclaimerRepository _repository;

  DisclaimerBloc(this._repository) : super(const DisclaimerState()) {
    on<LoadDisclaimerEvent>(_onLoadDisclaimer);
  }

  Future<void> _onLoadDisclaimer(
    LoadDisclaimerEvent event,
    Emitter<DisclaimerState> emit,
  ) async {
    emit(state.copyWith(status: DisclaimerStatus.loading));
    _logger.info({'text': '开始加载免责声明信息'});

    try {
      final projectLinks = await _repository.getProjectLinks();
      final authorInfo = await _repository.getAuthorInfo();
      _logger.info({'text': '免责声明信息加载成功'});
      emit(state.copyWith(
        status: DisclaimerStatus.success,
        projectLinks: projectLinks,
        authorInfo: authorInfo,
      ));
    } catch (e) {
      _logger.warn({'text': '免责声明信息加载失败', 'data': {'error': e.toString()}});
      emit(state.copyWith(
        status: DisclaimerStatus.error,
        errorMessage: '加载声明信息失败: $e',
      ));
    }
  }
}