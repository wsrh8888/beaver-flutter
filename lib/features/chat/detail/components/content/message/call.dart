import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallMessage extends StatelessWidget {
  final MessageModel message;
  final bool isSelf;
  const CallMessage({super.key, required this.message, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    final color = isSelf ? Colors.white : const Color(0xFF2D3436);
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
