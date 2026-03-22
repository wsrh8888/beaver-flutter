import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatEditor extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;

  const ChatEditor({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 78.w, maxHeight: 132.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: const Color(0xFFE7ECF1)),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: null,
        minLines: 3,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        onChanged: onChanged,
        onSubmitted: (_) => onSubmitted(),
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2D3436)),
        decoration: InputDecoration(
          hintText: 'Type a message...',
          hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFFAFB8C2)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
        ),
      ),
    );
  }
}
