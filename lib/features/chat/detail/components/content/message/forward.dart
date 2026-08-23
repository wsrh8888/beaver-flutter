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
import 'package:beaver/router/routes.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForwardMessage extends StatelessWidget {
  final ForwardMsg msg;
  final bool isSelf;
  const ForwardMessage({super.key, required this.msg, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    final textColor =
        isSelf ? AppColors.chatBubbleSelfText : AppColors.chatBubbleOtherText;
    final subColor = isSelf
        ? AppColors.chatBubbleSelfText.withOpacity(0.7)
        : AppColors.chatBubbleOtherSubText;
    final footerColor = isSelf
        ? AppColors.chatBubbleSelfText.withOpacity(0.6)
        : AppColors.textPlaceholder;

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.chatForwardDetail, extra: {
          'title': msg.title,
          'recordId': msg.recordId,
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            msg.title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            "${msg.count} 条消息",
            style: TextStyle(fontSize: 12.sp, color: subColor),
          ),
          Divider(color: Colors.black.withOpacity(0.05)),
          Text(
            "聊天记录",
            style: TextStyle(fontSize: 11.sp, color: footerColor),
          ),
        ],
      ),
    );
  }
}
