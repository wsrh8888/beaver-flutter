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
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallMessage extends StatelessWidget {
  final MessageModel message;
  final bool isSelf;
  const CallMessage({super.key, required this.message, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    final color =
        isSelf ? AppColors.chatBubbleSelfText : AppColors.chatBubbleOtherText;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.call,
          size: 18.w,
          color: color,
        ),
        SizedBox(width: 8.w),
        Text(
          message.content,
          style: TextStyle(fontSize: 14.sp, color: color),
        ),
      ],
    );
  }
}
