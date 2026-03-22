import 'package:beaver/features/chat/detail/components/message/message_item.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!widget.isLoadingMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 8.w),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        // Determine if we should show nickname (e.g. for group chats, but here we'll simplify)
        final isGroup = message.conversationId.startsWith('group_');
        
        return MessageItem(
          key: ValueKey(message.id),
          message: message,
          showNickname: isGroup,
        );
      },
      reverse: false, // Desktop/Mobile usually shows messages from top to bottom or bottom up depending on app. 
      // Most IMs use reverse: true for performance and auto-scrolling to bottom, but we need to align with current logic.
    );
  }
}
