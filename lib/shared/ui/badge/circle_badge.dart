import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 圈子会话绿色标识（对齐 PC MessageLeft .circle-badge）
class CircleBadge extends StatelessWidget {
  const CircleBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18.w,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EF),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Text(
        '圈子',
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF16A34A),
          height: 1,
        ),
      ),
    );
  }
}

bool isCircleConversation(String conversationId) {
  return conversationId.startsWith('circle_');
}
