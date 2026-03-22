import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MediaMessageContent extends StatelessWidget {
  final MessageModel message;

  const MediaMessageContent({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = message.isSent;
    final title = _resolveTitle(message.type);

    return Container(
      constraints: BoxConstraints(maxWidth: 200.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFFFFF3ED) : Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFF0F3F6)),
      ),
      child: Row(
        children: [
          Icon(
            _resolveIcon(message.type),
            size: 18.w,
            color: const Color(0xFFFF7D45),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '$title: ${message.content}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF2D3436),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _resolveTitle(MessageType type) {
    switch (type) {
      case MessageType.image:
        return '图片';
      case MessageType.video:
        return '视频';
      case MessageType.audio:
        return '语音';
      case MessageType.file:
        return '文件';
      case MessageType.emoji:
        return '表情';
      case MessageType.reply:
        return '回复';
      case MessageType.mergedForward:
        return '合并转发';
      case MessageType.call:
        return '通话';
      case MessageType.text:
      case MessageType.notification:
      case MessageType.recalled:
      case MessageType.system:
        return '消息';
    }
  }

  IconData _resolveIcon(MessageType type) {
    switch (type) {
      case MessageType.image:
        return Icons.image_outlined;
      case MessageType.video:
        return Icons.videocam_outlined;
      case MessageType.audio:
        return Icons.graphic_eq;
      case MessageType.file:
        return Icons.insert_drive_file_outlined;
      case MessageType.emoji:
        return Icons.face_outlined;
      case MessageType.reply:
        return Icons.reply_outlined;
      case MessageType.mergedForward:
        return Icons.format_list_bulleted_outlined;
      case MessageType.call:
        return Icons.phone_outlined;
      case MessageType.text:
      case MessageType.notification:
      case MessageType.recalled:
      case MessageType.system:
        return Icons.chat_bubble_outline;
    }
  }
}
