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

import 'package:beaver/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatEditor extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final FocusNode focusNode;
  final VoidCallback onTap;
  const ChatEditor({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.focusNode,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 40.w, maxHeight: 120.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        onTap: onTap,
        onSubmitted: (val) {
          if (val.trim().isNotEmpty) onSubmitted(val);
        },
        textInputAction: TextInputAction.send,
        maxLines: null,
        style: TextStyle(fontSize: 15.sp, color: AppColors.chatBubbleOtherText),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '发送消息',
          hintStyle: TextStyle(fontSize: 15.sp, color: AppColors.textPlaceholder),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10.w),
        ),
      ),
    );
  }
}
