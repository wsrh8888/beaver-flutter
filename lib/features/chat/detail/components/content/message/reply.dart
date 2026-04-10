import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReplyMessage extends StatelessWidget {
  final ReplyMsg msg;
  final bool isSelf;
  const ReplyMessage({super.key, required this.msg, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xFF2D3436);
    final subColor = const Color(0xFF636E72);
    final replyBg = Colors.black.withOpacity(0.05);

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
