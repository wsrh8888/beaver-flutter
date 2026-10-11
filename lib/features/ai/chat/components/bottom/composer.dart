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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiComposer extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final String hint;
  final VoidCallback onSend;
  final bool compact;

  const AiComposer({
    super.key,
    required this.controller,
    required this.sending,
    required this.hint,
    required this.onSend,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, compact ? 8.h : 12.h, 16.w, compact ? 12.h : 16.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEBEEF5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: compact ? 4 : 6,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: const BorderSide(color: Color(0xFFEBEEF5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: const BorderSide(color: Color(0xFFEBEEF5)),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            onPressed: sending ? null : onSend,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFFF7D45),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFFFD4B8),
            ),
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
