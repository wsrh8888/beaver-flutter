import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/cache/image.dart';
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
    if (_isSystemMessage(message.type)) {
      return _buildSystemMessage();
    }

    final isMine = message.isSent;

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
                    Flexible(child: _buildContent(context)),
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

  Widget _buildContent(BuildContext context) {
    switch (message.type) {
      case MessageType.text:
        return _buildTextContent();
      case MessageType.image:
        return _buildImageContent();
      case MessageType.emoji:
        return _buildEmojiContent();
      case MessageType.notification:
      case MessageType.recalled:
      case MessageType.system:
        return _buildSystemMessage();
      default:
        return _buildMediaContent();
    }
  }

  Widget _buildTextContent() {
    final isMine = message.isSent;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.w),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFFFF7D45) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.w),
          topRight: Radius.circular(16.w),
          bottomLeft: Radius.circular(isMine ? 16.w : 2.w),
          bottomRight: Radius.circular(isMine ? 2.w : 16.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _parseRichText(message.content, isMine),
    );
  }

  Widget _parseRichText(String text, bool isMine) {
    final List<InlineSpan> spans = [];
    final RegExp emojiRegex = RegExp(r'\[([^\]]+)\]');
    int lastMatchEnd = 0;

    for (final Match match in emojiRegex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(
            fontSize: 14.sp,
            color: isMine ? Colors.white : const Color(0xFF2D3436),
            height: 1.4,
          ),
        ));
      }
      
      // For now, render the [emoji] as text or a placeholder
      // In a real app, this would be a WidgetSpan with an Image
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            match.group(0)!, 
            style: TextStyle(
              fontSize: 14.sp, 
              color: isMine ? Colors.white70 : Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
      
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(
          fontSize: 14.sp,
          color: isMine ? Colors.white : const Color(0xFF2D3436),
          height: 1.4,
        ),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildImageContent() {
    return Container(
      constraints: BoxConstraints(maxWidth: 200.w),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: BeaverCachedImage(
        fileKey: message.content,
        width: 200.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildEmojiContent() {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: BeaverCachedImage(
        fileKey: message.content,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMediaContent() {
    final isMine = message.isSent;
    return Container(
      constraints: BoxConstraints(maxWidth: 220.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFFFFF3ED) : Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFF0F3F6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _resolveIcon(message.type),
            size: 20.w,
            color: const Color(0xFFFF7D45),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              message.content,
              maxLines: 1,
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

  Widget _buildSystemMessage() {
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
        padding: EdgeInsets.only(right: 6.w, bottom: 4.w),
        child: SizedBox(
          width: 14.w,
          height: 14.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2, 
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7D45)),
          ),
        ),
      );
    }
    if (message.status == MessageStatus.failed) {
      return Padding(
        padding: EdgeInsets.only(right: 6.w, bottom: 4.w),
        child: Icon(Icons.error, size: 18.w, color: Colors.redAccent),
      );
    }
    return const SizedBox.shrink();
  }

  bool _isSystemMessage(MessageType type) {
    return type == MessageType.system || 
           type == MessageType.notification || 
           type == MessageType.recalled;
  }

  IconData _resolveIcon(MessageType type) {
    switch (type) {
      case MessageType.video:
        return Icons.videocam_outlined;
      case MessageType.audio:
        return Icons.graphic_eq;
      case MessageType.file:
        return Icons.insert_drive_file_outlined;
      case MessageType.reply:
        return Icons.reply_outlined;
      case MessageType.mergedForward:
        return Icons.format_list_bulleted_outlined;
      case MessageType.call:
        return Icons.phone_outlined;
      default:
        return Icons.chat_bubble_outline;
    }
  }
}
