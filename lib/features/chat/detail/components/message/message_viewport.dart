import 'package:beaver/features/chat/detail/components/message/message_item.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageViewport extends StatelessWidget {
  final List<MessageModel> messages;
  final bool isLoading;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const MessageViewport({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF99A3AD),
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification && 
            notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100 && 
            !isLoadingMore) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.w),
        itemCount: messages.length + 1,
        itemBuilder: (context, index) {
          if (index == messages.length) {
            return isLoadingMore
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.w),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          final message = messages[messages.length - 1 - index];
          return MessageItem(
            key: ValueKey(message.id),
            message: message,
          );
        },
      ),
    );
  }
}
