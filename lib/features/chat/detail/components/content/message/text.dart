import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextMessage extends StatelessWidget {
  final TextMsg msg;
  final bool isSelf;
  const TextMessage({super.key, required this.msg, this.isSelf = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      msg.content,
      style: TextStyle(
        fontSize: 16.sp,
        color: const Color(0xFF2D3436),
        height: 1.4,
      ),
    );
  }
}
