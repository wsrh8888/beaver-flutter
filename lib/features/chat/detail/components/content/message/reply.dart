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
