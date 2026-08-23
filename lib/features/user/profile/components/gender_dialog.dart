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

class GenderDialog extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onSave;
  final VoidCallback onCancel;

  const GenderDialog({
    super.key,
    required this.initialValue,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<GenderDialog> createState() => _GenderDialogState();
}

class _GenderDialogState extends State<GenderDialog> {
  late int _gender;

  @override
  void initState() {
    super.initState();
    _gender = widget.initialValue == 0 ? 1 : widget.initialValue;
  }

  void _save() {
    widget.onSave(_gender);
  }

  @override
  Widget build(BuildContext context) {
    return BeaverDialog(
      title: '选择性别',
      onConfirm: _save,
      onCancel: widget.onCancel,
      child: Column(
        children: [
          _buildItem('男', 1),
          SizedBox(height: 12.w),
          _buildItem('女', 2),
          SizedBox(height: 12.w),
        ],
      ),
    );
  }

  Widget _buildItem(String label, int value) {
    bool active = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFF7F2) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(
            color: active ? const Color(0xFFFF7D45) : Colors.transparent,
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                color: active ? const Color(0xFFFF7D45) : const Color(0xFF2D3436),
              ),
            ),
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? const Color(0xFFFF7D45) : const Color(0xFFDCDFE6),
                  width: 1.5.w,
                ),
              ),
              alignment: Alignment.center,
              child: active 
                ? Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF7D45),
                    ),
                  )
                : null,
            ),
          ],
        ),
      ),
    );
  }
}
