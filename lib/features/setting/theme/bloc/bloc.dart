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
import 'package:beaver/features/setting/theme/bloc/event.dart';
import 'package:beaver/features/setting/theme/bloc/state.dart';
import 'package:beaver/features/setting/theme/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('setting-theme');

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository _repository;

  ThemeBloc(this._repository) : super(const ThemeState()) {
    on<LoadThemesEvent>(_onLoadThemes);
    on<SelectThemeEvent>(_onSelectTheme);
  }

  Future<void> _onLoadThemes(
    LoadThemesEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(status: ThemeStatus.loading));
    _logger.info({'text': '加载主题列表'});

    try {
      final availableThemes = await _repository.getAvailableThemes();
      final currentTheme = await _repository.getCurrentTheme();
      final currentThemeConfig = availableThemes.firstWhere(
        (theme) => theme.name == currentTheme,
        orElse: () => availableThemes.first,
      );

      _logger.info({
        'text': '加载主题列表成功',
        'data': {'count': availableThemes.length, 'currentTheme': currentTheme},
      });
      emit(state.copyWith(
        status: ThemeStatus.success,
        availableThemes: availableThemes,
        currentTheme: currentTheme,
        currentThemeConfig: currentThemeConfig,
      ));
    } catch (e) {
      _logger.error({'text': '加载主题列表失败', 'data': {'error': e.toString()}});
      emit(state.copyWith(
        status: ThemeStatus.error,
        errorMessage: '加载主题失败: $e',
      ));
    }
  }

  Future<void> _onSelectTheme(
    SelectThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(status: ThemeStatus.loading));
    _logger.info({'text': '切换主题', 'data': {'themeName': event.themeName}});

    try {
      await _repository.setTheme(event.themeName);
      final currentThemeConfig = state.availableThemes.firstWhere(
        (theme) => theme.name == event.themeName,
        orElse: () => state.availableThemes.first,
      );

      _logger.info({'text': '切换主题成功', 'data': {'themeName': event.themeName}});
      emit(state.copyWith(
        status: ThemeStatus.success,
        currentTheme: event.themeName,
        currentThemeConfig: currentThemeConfig,
      ));
    } catch (e) {
      _logger.error({
        'text': '切换主题失败',
        'data': {'themeName': event.themeName, 'error': e.toString()},
      });
      emit(state.copyWith(
        status: ThemeStatus.error,
        errorMessage: '设置主题失败: $e',
      ));
    }
  }
}

