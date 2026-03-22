import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextMessageContent extends StatelessWidget {
  final MessageModel message;

  const TextMessageContent({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = message.isSent;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFFFF7D45) : Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6.w,
            offset: Offset(0, 2.w),
          ),
        ],
      ),
      child: Text(
        message.content,
        style: TextStyle(
          fontSize: 14.sp,
          height: 1.45,
          color: isMine ? Colors.white : const Color(0xFF2D3436),
        ),
      ),
    );
  }
}
