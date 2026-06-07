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
