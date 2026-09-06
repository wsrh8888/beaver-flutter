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
import 'package:beaver/features/workbench/home/bloc/event.dart';
import 'package:beaver/features/workbench/home/bloc/state.dart';
import 'package:beaver/features/workbench/home/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('workbench-home');

class WorkbenchHomeBloc extends Bloc<WorkbenchHomeEvent, WorkbenchHomeState> {
  final WorkbenchHomeRepository _repository;

  WorkbenchHomeBloc(this._repository) : super(const WorkbenchHomeState()) {
    on<LoadWorkbenchHomeEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadWorkbenchHomeEvent event,
    Emitter<WorkbenchHomeState> emit,
  ) async {
    emit(state.copyWith(status: WorkbenchHomeStatus.loading));
    _logger.info({'text': '加载工作台应用'});

    final res = await _repository.loadApps();
    if (res.code != 0) {
      _logger.warn({'text': '加载工作台应用失败', 'data': {'code': res.code, 'msg': res.msg}});
      emit(state.copyWith(
        status: WorkbenchHomeStatus.error,
        errorMessage: res.msg.isNotEmpty ? res.msg : '加载应用失败',
      ));
      return;
    }

    _logger.info({'text': '加载工作台应用成功', 'data': {'groupCount': res.result?.groups.length ?? 0}});
    emit(state.copyWith(
      status: WorkbenchHomeStatus.success,
      groups: res.result?.groups ?? [],
    ));
  }
}
