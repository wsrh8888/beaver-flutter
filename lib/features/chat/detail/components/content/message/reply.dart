import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReplyMessage extends StatelessWidget {
  final ReplyMsg msg;
  final bool isSelf;
  const ReplyMessage({super.key, required this.msg, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    final textColor = isSelf ? Colors.white : const Color(0xFF2D3436);
    final subColor = isSelf ? Colors.white70 : const Color(0xFF636E72);
    final replyBg = isSelf ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.05);

    return Column(
      crossAxisAlignment: isSelf
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
          margin: EdgeInsets.only(bottom: 4.w),
          decoration: BoxDecoration(
            color: replyBg,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: Text(
            "回复：${msg.originMsgId}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, color: subColor),
          ),
        ),
        if (msg.replyMsg?.textMsg != null)
          Text(
            msg.replyMsg!.textMsg!.content,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
              color: textColor,
            ),
          ),
      ],
    );
  }
}
