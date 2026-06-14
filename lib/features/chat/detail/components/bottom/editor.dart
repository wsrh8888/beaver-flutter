import 'package:beaver/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatEditor extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final FocusNode focusNode;
  final VoidCallback onTap;
  const ChatEditor({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.focusNode,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 40.w, maxHeight: 120.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        onTap: onTap,
        onSubmitted: (val) {
          if (val.trim().isNotEmpty) onSubmitted(val);
        },
        textInputAction: TextInputAction.send,
        maxLines: null,
        style: TextStyle(fontSize: 15.sp, color: AppColors.chatBubbleOtherText),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '发送消息',
          hintStyle: TextStyle(fontSize: 15.sp, color: AppColors.textPlaceholder),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10.w),
        ),
      ),
    );
  }
}
