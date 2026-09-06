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
import 'package:beaver/features/setting/agreement/bloc/event.dart';
import 'package:beaver/features/setting/agreement/bloc/state.dart';
import 'package:beaver/features/setting/agreement/data/repositories/repository.dart';

final _logger = Logger('setting-agreement');

class AgreementBloc extends Bloc<AgreementEvent, AgreementState> {
  final AgreementRepository _repository;

  AgreementBloc(this._repository) : super(const AgreementState()) {
    on<LoadAgreementEvent>(_onLoadAgreement);
  }

  Future<void> _onLoadAgreement(
    LoadAgreementEvent event,
    Emitter<AgreementState> emit,
  ) async {
    emit(state.copyWith(status: AgreementStatus.loading));
    _logger.info({'text': '开始加载用户协议'});

    try {
      final agreement = await _repository.getAgreement();
      _logger.info({'text': '用户协议加载成功'});
      emit(state.copyWith(
        status: AgreementStatus.success,
        agreement: agreement,
      ));
    } catch (e) {
      _logger.warn({'text': '用户协议加载失败', 'data': {'error': e.toString()}});
      emit(state.copyWith(
        status: AgreementStatus.error,
        errorMessage: '加载协议失败: $e',
      ));
    }
  }
}