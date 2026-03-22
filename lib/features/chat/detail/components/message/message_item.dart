import 'package:beaver/features/chat/detail/components/message/content/message_content_factory.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  final bool showNickname;

  const MessageItem({
    super.key,
    required this.message,
    this.showNickname = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = message.isSent;

    // TODO: Handle system/notification messages differently (centered, no avatar)
    if (_isSystemMessage(message.type)) {
      return MessageContentFactory.build(context, message);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine) _buildAvatar(),
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (showNickname && !isMine)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.w, left: 4.w),
                    child: Text(
                      message.nickname ?? '用户',
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72)),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isMine) _buildStatus(context),
                    Flexible(child: MessageContentFactory.build(context, message)),
                    if (!isMine) _buildTime(),
                  ],
                ),
                if (isMine) _buildTime(padding: EdgeInsets.only(top: 4.w)),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          if (isMine) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return BeaverAvatar(
      avatar: message.avatar ?? '',
      size: 36.w,
    );
  }

  Widget _buildTime({EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
      child: Text(
        DateFormat('HH:mm').format(message.createdAt),
        style: TextStyle(fontSize: 10.sp, color: const Color(0xFFB2BEC3)),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    if (message.status == MessageStatus.sending) {
      return Padding(
        padding: EdgeInsets.only(right: 4.w, bottom: 4.w),
        child: SizedBox(
          width: 12.w,
          height: 12.w,
          child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF7D45)),
        ),
      );
    }
    if (message.status == MessageStatus.failed) {
      return Padding(
        padding: EdgeInsets.only(right: 4.w, bottom: 4.w),
        child: Icon(Icons.error, size: 16.w, color: Colors.red),
      );
    }
    return const SizedBox.shrink();
  }

  bool _isSystemMessage(MessageType type) {
    return type == MessageType.system || 
           type == MessageType.notification || 
           type == MessageType.recalled;
  }
}
