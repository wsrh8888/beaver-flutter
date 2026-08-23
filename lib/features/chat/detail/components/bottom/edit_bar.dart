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

import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditMessageBar extends StatelessWidget {
  final MessageModel message;

  const EditMessageBar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final preview = message.content;
    final shortPreview = preview.length > 40
        ? '${preview.substring(0, 40)}...'
        : preview;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        border: Border(
          left: BorderSide(color: const Color(0xFFFF7D45), width: 3.w),
          bottom: BorderSide(color: const Color(0xFFE9EDF2), width: 1.w),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF909399)),
                children: [
                  TextSpan(
                    text: '编辑消息：',
                    style: TextStyle(
                      color: const Color(0xFFFF7D45),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: shortPreview),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                context.read<ChatBloc>().add(const CancelEditMessageEvent()),
            child: Icon(Icons.close, size: 18.w, color: const Color(0xFF909399)),
          ),
        ],
      ),
    );
  }
}
