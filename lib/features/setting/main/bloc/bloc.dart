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
import 'package:beaver/features/setting/main/bloc/event.dart';
import 'package:beaver/features/setting/main/bloc/state.dart';
import 'package:beaver/features/setting/main/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('setting-main');

class SettingMainBloc extends Bloc<SettingMainEvent, SettingMainState> {
  final SettingMainRepository _repository;

  SettingMainBloc(this._repository) : super(const SettingMainState()) {
    on<LoadSettingItemsEvent>(_onLoadSettingItems);
    on<ShowLogoutDialogEvent>(_onShowLogoutDialog);
    on<HideLogoutDialogEvent>(_onHideLogoutDialog);
    on<LogoutEvent>(_onLogout);
  }

  void _onLoadSettingItems(
    LoadSettingItemsEvent event,
    Emitter<SettingMainState> emit,
  ) {
    emit(state.copyWith(status: SettingMainStatus.loading));
    try {
      final items = _repository.getSettingItems();
      _logger.info({'text': '加载设置项成功', 'data': {'count': items.length}});
      emit(state.copyWith(
        status: SettingMainStatus.success,
        settingItems: items,
      ));
    } catch (e) {
      _logger.error({'text': '加载设置项失败', 'data': {'error': e.toString()}});
      emit(state.copyWith(
        status: SettingMainStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onShowLogoutDialog(
    ShowLogoutDialogEvent event,
    Emitter<SettingMainState> emit,
  ) {
    emit(state.copyWith(showLogoutDialog: true));
  }

  void _onHideLogoutDialog(
    HideLogoutDialogEvent event,
    Emitter<SettingMainState> emit,
  ) {
    emit(state.copyWith(showLogoutDialog: false));
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<SettingMainState> emit,
  ) async {
    // 这里执行退出登录逻辑
    emit(state.copyWith(status: SettingMainStatus.loading));
    _logger.info({'text': '执行退出登录'});
    try {
      // 模拟退出登录
      await Future.delayed(const Duration(seconds: 1));
      _logger.info({'text': '退出登录成功'});
      emit(state.copyWith(status: SettingMainStatus.success));
    } catch (e) {
      _logger.error({'text': '退出登录失败', 'data': {'error': e.toString()}});
      emit(state.copyWith(
        status: SettingMainStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
