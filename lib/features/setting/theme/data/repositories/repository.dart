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

