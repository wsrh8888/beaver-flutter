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

import 'package:beaver/features/chat/detail/components/content/message/text.dart';
import 'package:beaver/theme/colors.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReplyMessage extends StatelessWidget {
  final ReplyMsg msg;
  final bool isSelf;
  const ReplyMessage({super.key, required this.msg, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    final textColor =
        isSelf ? AppColors.chatBubbleSelfText : AppColors.chatBubbleOtherText;
    final subColor = isSelf
        ? AppColors.chatBubbleSelfText.withOpacity(0.7)
        : AppColors.chatBubbleOtherSubText;
    final replyBg = isSelf
        ? Colors.black.withOpacity(0.08)
        : const Color(0xFFF7F7F7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
          margin: EdgeInsets.only(bottom: 6.w),
          decoration: BoxDecoration(
            color: replyBg,
            borderRadius: BorderRadius.circular(6.w),
            border: Border(
              left: BorderSide(color: const Color(0xFFFF7D45), width: 3.w),
            ),
          ),
          child: Text(
            "回复：${msg.originMsgId}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11.sp, color: subColor),
          ),
        ),
        if (msg.replyMsg?.textMsg != null)
          DefaultTextStyle(
            style: TextStyle(color: textColor),
            child: TextMessage(
              msg: msg.replyMsg!.textMsg!,
              isSelf: isSelf,
              emojiSize: 28.w,
              fontSize: 14.sp,
            ),
          ),
      ],
    );
  }
}
