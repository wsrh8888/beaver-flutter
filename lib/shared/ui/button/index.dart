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
import 'package:beaver/theme/colors.dart';

enum BeaverButtonType { filled, outline }

class BeaverButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool loading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BeaverButtonType type;

  const BeaverButton({
    super.key,
    required this.text,
    this.onPressed,
    this.disabled = false,
    this.loading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.borderRadius,
    this.type = BeaverButtonType.filled,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !disabled && !loading && onPressed != null;
    final isOutline = type == BeaverButtonType.outline;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: (isEnabled && !isOutline)
              ? (backgroundColor != null ? null : AppColors.primaryGradient)
              : null,
          color: isOutline 
              ? Colors.transparent 
              : (backgroundColor != null ? (isEnabled ? backgroundColor : Colors.grey[300]) : (isEnabled ? null : Colors.grey[300])),
          border: isOutline 
              ? Border.all(color: (isEnabled ? (backgroundColor ?? const Color(0xFFFF7D45)) : Colors.grey[300]!), width: 1) 
              : null,
          borderRadius: borderRadius ?? BorderRadius.circular(14),
          boxShadow: (isEnabled && !isOutline)
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF7D45).withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: isOutline ? (backgroundColor ?? const Color(0xFFFF7D45)) : (textColor ?? Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: isOutline 
                      ? (backgroundColor ?? const Color(0xFFFF7D45)) 
                      : (textColor ?? Colors.white),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
