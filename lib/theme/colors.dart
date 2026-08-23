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

class AppColors {
  static const Color primary = Color(0xFFFF7D45);
  static const Color primaryDark = Color(0xFFE86835);
  static const Color background = Colors.white;
  static const Color inputBackground = Color(0xFFF9FAFB);
  static const Color textMain = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textPlaceholder = Color(0xFFB2BEC3);
  static const Color error = Color(0xFFFF7D45);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient topGradient = LinearGradient(
    colors: [Color(0x1AFF7D45), Color(0x00FFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 聊天页（对标微信）
  static const Color chatBackground = Color(0xFFEDEDED);
  static const Color chatBubbleSelf = primary;
  static const Color chatBubbleSelfText = Colors.white;
  static const Color chatBubbleOther = Color(0xFFFFFFFF);
  static const Color chatBubbleOtherText = Color(0xFF191919);
  static const Color chatBubbleOtherSubText = Color(0xFF888888);
  static const Color chatInputBackground = Color(0xFFF7F7F7);
}
