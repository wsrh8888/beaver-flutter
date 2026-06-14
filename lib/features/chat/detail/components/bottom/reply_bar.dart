import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReplyMessageBar extends StatelessWidget {
  final MessageModel message;

  const ReplyMessageBar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final senderName = message.nickname?.isNotEmpty == true
        ? message.nickname!
        : message.userId;
    final preview = message.previewText;
    final shortPreview =
        preview.length > 40 ? '${preview.substring(0, 40)}...' : preview;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        border: Border(
          left: BorderSide(color: const Color(0xFF2196F3), width: 3.w),
          bottom: BorderSide(color: const Color(0xFFE9EDF2), width: 1.w),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF909399),
                ),
                children: [
                  TextSpan(
                    text: '回复 $senderName：',
                    style: TextStyle(
                      color: const Color(0xFF2196F3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: shortPreview),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                context.read<ChatBloc>().add(const CancelReplyMessageEvent()),
            child: Icon(
              Icons.close,
              size: 18.w,
              color: const Color(0xFF909399),
            ),
          ),
        ],
      ),
    );
  }
}
