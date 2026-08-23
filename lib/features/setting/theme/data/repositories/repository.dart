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

import 'package:flutter/material.dart';
import 'package:beaver/features/setting/theme/data/models/theme.dart';

class ThemeRepository {
  Future<List<ThemeConfig>> getAvailableThemes() async {
    // 模拟获取可用主题
    await Future.delayed(const Duration(seconds: 1));
    return [
      ThemeConfig(
        name: 'default',
        label: '默认主题',
        colors: ThemeColors(
          primary: const Color(0xFFFF7D45),
          background: const Color(0xFFF9FAFB),
          textBody: const Color(0xFF636E72),
          divider: const Color(0xFFEBEEF5),
        ),
      ),
      ThemeConfig(
        name: 'dark',
        label: '深色主题',
        colors: ThemeColors(
          primary: const Color(0xFFFF7D45),
          background: const Color(0xFF1A1A1A),
          textBody: const Color(0xFFB2BEC3),
          divider: const Color(0xFF2D3436),
        ),
      ),
      ThemeConfig(
        name: 'blue',
        label: '蓝色主题',
        colors: ThemeColors(
          primary: const Color(0xFF3498DB),
          background: const Color(0xFFF9FAFB),
          textBody: const Color(0xFF636E72),
          divider: const Color(0xFFEBEEF5),
        ),
      ),
      ThemeConfig(
        name: 'green',
        label: '绿色主题',
        colors: ThemeColors(
          primary: const Color(0xFF27AE60),
          background: const Color(0xFFF9FAFB),
          textBody: const Color(0xFF636E72),
          divider: const Color(0xFFEBEEF5),
        ),
      ),
    ];
  }

  Future<String> getCurrentTheme() async {
    // 模拟获取当前主题
    await Future.delayed(const Duration(milliseconds: 500));
    return 'default';
  }

  Future<void> setTheme(String themeName) async {
    // 模拟设置主题
    await Future.delayed(const Duration(seconds: 1));
  }
}

