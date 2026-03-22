import 'package:beaver/features/chat/detail/components/message/content/media_message_content.dart';
import 'package:beaver/features/chat/detail/components/message/content/text_message_content.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageContentFactory {
  const MessageContentFactory._();

  static Widget build(BuildContext context, MessageModel message) {
    switch (message.type) {
      case MessageType.text:
        return TextMessageContent(message: message);
      case MessageType.image:
      case MessageType.video:
      case MessageType.audio:
      case MessageType.file:
      case MessageType.emoji:
      case MessageType.reply:
      case MessageType.mergedForward:
      case MessageType.call:
        return MediaMessageContent(message: message);
      case MessageType.notification:
      case MessageType.recalled:
      case MessageType.system:
        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 24.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F6),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Text(
              message.content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF747D8C),
                height: 1.2,
              ),
            ),
          ),
        );
    }
  }
}

