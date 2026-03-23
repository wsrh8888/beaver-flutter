import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MergedForwardMessage extends StatelessWidget {
  final ForwardMsg msg;
  final bool isSelf;
  const MergedForwardMessage({super.key, required this.msg, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(msg.title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFF2D3436))),
        SizedBox(height: 8.w),
        Text("${msg.count} 条消息", style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72))),
        const Divider(),
        Text("聊天记录", style: TextStyle(fontSize: 11.sp, color: const Color(0xFFB2BEC3))),
      ],
    );
  }
}
