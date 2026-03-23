import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecalledMessage extends StatelessWidget {
  final MessageModel message;
  final bool isSelf;
  const RecalledMessage({super.key, required this.message, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    final text = isSelf ? "你撤回了一条消息" : "对方撤回了一条消息";
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFFB2BEC3)),
        ),
      ),
    );
  }
}
