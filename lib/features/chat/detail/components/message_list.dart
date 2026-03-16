import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/chat/detail/data/models/message.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';

class MessageList extends StatefulWidget {
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
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == 0) {
        widget.onLoadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        reverse: false,
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.w),
        itemCount: widget.messages.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (widget.isLoadingMore && index == 0) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final messageIndex = widget.isLoadingMore ? index - 1 : index;
          if (messageIndex < 0 || messageIndex >= widget.messages.length) {
            return const SizedBox();
          }

          final message = widget.messages[messageIndex];
          return _buildMessageItem(message);
        },
      ),
    );
  }

  Widget _buildMessageItem(MessageModel message) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.w),
      child: message.isSent ? _buildSentMessage(message) : _buildReceivedMessage(message),
    );
  }

  Widget _buildSentMessage(MessageModel message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 16.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7D45),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.w),
                topRight: Radius.circular(4.w),
                bottomLeft: Radius.circular(20.w),
                bottomRight: Radius.circular(20.w),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF7D45).withOpacity(0.1),
                  offset: Offset(0, 4.w),
                  blurRadius: 12.w,
                ),
              ],
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.w,
                lineHeight: 1.4,
              ),
            ),
          ),
        ),
        BeaverAvatar(
          size: 64.w,
        ),
      ],
    );
  }

  Widget _buildReceivedMessage(MessageModel message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BeaverAvatar(
          size: 64.w,
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 16.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                topRight: Radius.circular(20.w),
                bottomLeft: Radius.circular(20.w),
                bottomRight: Radius.circular(20.w),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 4.w),
                  blurRadius: 12.w,
                ),
              ],
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: const Color(0xFF2D3436),
                fontSize: 30.w,
                lineHeight: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

