import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationMessage extends StatelessWidget {
  final MessageModel message;
  const NotificationMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 8.w),
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
        decoration: BoxDecoration(color: const Color(0xFFEBEEF5), borderRadius: BorderRadius.circular(12.w)),
        child: Text(
          message.content,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72)),
        ),
      ),
    );
  }
}
