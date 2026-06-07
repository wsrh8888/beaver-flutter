import 'package:beaver/theme/colors.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceMessage extends StatelessWidget {
  final VoiceMsg msg;
  final bool isSelf;

  const VoiceMessage({
    super.key,
    required this.msg,
    this.isSelf = false,
  });

  @override
  Widget build(BuildContext context) {
    final duration = msg.duration ?? 1;
    final color = isSelf
        ? AppColors.chatBubbleSelfText
        : AppColors.chatBubbleOtherText;
    final width = (72 + duration * 6).clamp(96, 200).toDouble().w;

    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isSelf) ...[
            Icon(Icons.volume_up_rounded, size: 18.w, color: color),
            SizedBox(width: 8.w),
          ],
          Text(
            '${duration}s',
            style: TextStyle(
              fontSize: 15.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isSelf) ...[
            SizedBox(width: 8.w),
            Icon(Icons.volume_up_rounded, size: 18.w, color: color),
          ],
        ],
      ),
    );
  }
}
