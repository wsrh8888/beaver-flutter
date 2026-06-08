import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/components/content/message/text.dart';
import 'package:beaver/features/chat/detail/components/content/message/image.dart';
import 'package:beaver/features/chat/detail/components/content/message/video.dart';
import 'package:beaver/features/chat/detail/components/content/message/audio.dart';
import 'package:beaver/features/chat/detail/components/content/message/voice.dart';
import 'package:beaver/features/chat/detail/components/content/message/file.dart';
import 'package:beaver/features/chat/detail/components/content/message/emoji.dart';
import 'package:beaver/features/chat/detail/components/content/message/notification.dart';
import 'package:beaver/features/chat/detail/components/content/message/recalled.dart';
import 'package:beaver/features/chat/detail/components/content/message/reply.dart';
import 'package:beaver/features/chat/detail/components/content/message/forward.dart';
import 'package:beaver/features/chat/detail/components/content/message/call.dart';
import 'package:beaver/features/chat/detail/components/content/message/markdown.dart';
import 'package:beaver/features/chat/detail/components/content/popup/action_menu.dart';
import 'package:beaver/theme/colors.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.status == ChatStatus.loading) {
          return ColoredBox(
            color: AppColors.chatBackground,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final messages = state.messages;
        final isMultiSelect = state.status == ChatStatus.multiSelect;

        return Container(
          color: AppColors.chatBackground,
          child: ListView.builder(
          reverse: true,
          padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 12.w),
          itemCount: messages.length + 1,
          itemBuilder: (context, index) {
            if (index == messages.length) {
              if (state.hasMore && !state.isLoadingMore) {
                // 使用 postFrameCallback 避免在 build 过程中直接 add event
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<ChatBloc>().add(const LoadMoreMessagesEvent());
                });
                return _buildLoader();
              }
              return SizedBox(height: 20.w);
            }
            final message = messages[index];
            final isSelf = message.isSent;
            final isSelected = state.selectedMessageIds.contains(message.id);

            if (message.type == MessageType.notification ||
                message.type == MessageType.recalled) {
              return _buildFullWidthMessage(message, isSelf);
            }

            return _buildMessageRow(context, message, isSelf, isSelected, isMultiSelect);
          },
        ),
        );
      },
    );
  }

  Widget _buildFullWidthMessage(MessageModel message, bool isSelf) {
    if (message.type == MessageType.notification)
      return NotificationMessage(message: message);
    if (message.type == MessageType.recalled)
      return RecalledMessage(message: message, isSelf: isSelf);
    return const SizedBox.shrink();
  }

  Widget _buildMessageRow(
    BuildContext context,
    MessageModel message,
    bool isSelf,
    bool isSelected,
    bool isMultiSelect,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSelf
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (isMultiSelect) _buildCheckbox(context, message.id, isSelected),
          if (!isSelf) ...[_buildAvatar(message.avatar), SizedBox(width: 8.w)],
          _buildBubble(context, message, isSelf),
          if (isSelf) ...[SizedBox(width: 8.w), _buildAvatar(message.avatar)],
        ],
      ),
    );
  }

  Widget _buildAvatar(String? avatar) => BeaverCachedImage(
    fileUrl: avatar,
    type: CacheType.avatar,
    width: 36.w,
    height: 36.w,
    borderRadius: 8.w, // Match AI 4.2 spec
    fit: BoxFit.cover,
  );

  Widget _buildCheckbox(BuildContext context, String id, bool isSelected) {
    return GestureDetector(
      onTap: () =>
          context.read<ChatBloc>().add(ToggleMessageSelectionEvent(id)),
      child: Container(
        margin: EdgeInsets.only(right: 12.w, top: 8.w),
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF7D45)
                : const Color(0xFFB2BEC3),
            width: 2.w,
          ),
          color: isSelected ? const Color(0xFFFF7D45) : Colors.transparent,
        ),
        child: isSelected
            ? Icon(Icons.check, size: 14.w, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildBubble(BuildContext context, MessageModel message, bool isSelf) {
    final isEmoji = message.type == MessageType.emoji;
    return GestureDetector(
      onLongPressStart: (details) =>
          showMessageActionMenu(context, message, details.globalPosition),
      child: Container(
        padding: isEmoji
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
        constraints: BoxConstraints(maxWidth: 0.7.sw),
        decoration: isEmoji
            ? null
            : BoxDecoration(
                color: isSelf
                    ? AppColors.chatBubbleSelf
                    : AppColors.chatBubbleOther,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.w),
                  topRight: Radius.circular(4.w),
                  bottomLeft: isSelf
                      ? Radius.circular(4.w)
                      : Radius.circular(2.w),
                  bottomRight: isSelf
                      ? Radius.circular(2.w)
                      : Radius.circular(4.w),
                ),
              ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: isSelf
                ? AppColors.chatBubbleSelfText
                : AppColors.chatBubbleOtherText,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _resolveMessageWidget(message, isSelf),
              if (isSelf && message.status == MessageStatus.failed)
                Padding(
                  padding: EdgeInsets.only(top: 6.w),
                  child: GestureDetector(
                    onTap: () => context.read<ChatBloc>().add(
                      RetrySendMessageEvent(message.id),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 14.w,
                          color: isSelf
                              ? AppColors.chatBubbleSelfText.withValues(alpha: 0.9)
                              : const Color(0xFFFF5252),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '发送失败，点击重试',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isSelf
                                ? AppColors.chatBubbleSelfText.withValues(alpha: 0.9)
                                : const Color(0xFFFF5252),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (message.isEdited && !isEmoji)
                Padding(
                  padding: EdgeInsets.only(top: 4.w),
                  child: Text(
                    '已编辑',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isSelf
                          ? AppColors.chatBubbleSelfText.withValues(alpha: 0.7)
                          : const Color(0xFF909399),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _resolveMessageWidget(MessageModel message, bool isSelf) {
    final m = message.msg;
    switch (message.type) {
      case MessageType.text:
        return TextMessage(msg: m.textMsg ?? TextMsg(content: '不支持的格式'), isSelf: isSelf);
      case MessageType.image:
        return m.imageMsg == null
            ? const SizedBox()
            : ImageMessage(msg: m.imageMsg!, messageId: message.id);
      case MessageType.video:
        return m.videoMsg == null
            ? const SizedBox()
            : VideoMessage(msg: m.videoMsg!, messageId: message.id);
      case MessageType.audio:
        return m.audioFileMsg == null ? const SizedBox() : AudioMessage(msg: m.audioFileMsg!, isSelf: isSelf);
      case MessageType.voice:
        return m.voiceMsg == null
            ? const SizedBox()
            : VoiceMessage(msg: m.voiceMsg!, isSelf: isSelf);
      case MessageType.file:
        return m.fileMsg == null ? const SizedBox() : FileMessage(msg: m.fileMsg!, isSelf: isSelf);
      case MessageType.emoji:
        return m.emojiMsg == null ? const SizedBox() : EmojiMessage(msg: m.emojiMsg!);
      case MessageType.reply:
        return m.replyMsg == null ? const SizedBox() : ReplyMessage(msg: m.replyMsg!, isSelf: isSelf);
      case MessageType.mergedForward:
        return m.forwardMsg == null ? const SizedBox() : ForwardMessage(msg: m.forwardMsg!, isSelf: isSelf);
      case MessageType.call:
        return CallMessage(message: message, isSelf: isSelf);
      case MessageType.markdown:
        return m.markdownMsg == null
            ? const SizedBox()
            : MarkdownMessage(msg: m.markdownMsg!, isSelf: isSelf);
      default:
        return TextMessage(msg: m.textMsg ?? TextMsg(content: '未知消息'), isSelf: isSelf);
    }
  }

  Widget _buildLoader() => Container(
    padding: EdgeInsets.symmetric(vertical: 16.w),
    alignment: Alignment.center,
    child: SizedBox(
      width: 24.w,
      height: 24.w,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        color: Color(0xFFB2BEC3),
      ),
    ),
  );
}
