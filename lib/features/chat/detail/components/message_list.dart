import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/shared/ui/avatar/index.dart';

class MessageList extends StatelessWidget {
  final List<MessageModel> messages;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const MessageList({
    super.key,
    required this.messages,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageItem(message);
      },
    );
  }

  Widget _buildMessageItem(MessageModel message) {
    final isMe = message.isSent;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) BeaverAvatar(url: '', size: 36.w, nickname: message.userId),
          SizedBox(width: 8.w),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isMe ? Colors.orange : Colors.white,
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Text(
                message.content,
                style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 16.sp, height: 1.4),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          if (isMe) BeaverAvatar(url: '', size: 36.w, nickname: 'Me'),
        ],
      ),
    );
  }
}
