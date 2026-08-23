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
import 'package:beaver/shared/ui/dialog/index.dart';

class BioDialog extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onSave;
  final VoidCallback onCancel;

  const BioDialog({
    super.key,
    required this.initialValue,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<BioDialog> createState() => _BioDialogState();
}

class _BioDialogState extends State<BioDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BeaverDialog(
      title: '修改个人简介',
      onConfirm: _save,
      onCancel: widget.onCancel,
      child: Column(
        children: [
          Container(
            height: 120.w, // 240rpx
            padding: EdgeInsets.all(12.w), // 24rpx
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.w), // 24rpx
            ),
            child: TextField(
              controller: _controller,
              maxLines: 5,
              maxLength: 100,
              autofocus: true,
              style: TextStyle(
                fontSize: 14.sp, // 28rpx
                color: const Color(0xFF2D3436),
                height: 1.5,
              ),
              decoration: const InputDecoration(
                hintText: '介绍一下自己，让更多人了解你',
                hintStyle: TextStyle(color: Color(0xFFB2BEC3)),
                border: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SizedBox(height: 8.w),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_controller.text.length}/100',
              style: TextStyle(
                fontSize: 11.sp, // 22rpx
                color: const Color(0xFFB2BEC3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
