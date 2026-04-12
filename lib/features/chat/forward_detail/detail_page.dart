import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/features/chat/detail/components/content/message/text.dart';
import 'package:beaver/features/chat/detail/components/content/message/image.dart';
import 'package:beaver/features/chat/detail/components/content/message/video.dart';
import 'package:beaver/features/chat/detail/components/content/message/audio.dart';
import 'package:beaver/features/chat/detail/components/content/message/file.dart';
import 'package:beaver/features/chat/detail/components/content/message/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/detail_bloc.dart';
import 'bloc/detail_event.dart';
import 'bloc/detail_state.dart';

class ForwardDetailPage extends StatelessWidget {
  final String title;
  final String? recordId;

  const ForwardDetailPage({
    super.key,
    required this.title,
    this.recordId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ForwardDetailBloc();
        if (recordId != null) {
          bloc.add(FetchForwardDetailEvent(recordId!));
        }
        return bloc;
      },
      child: BlocConsumer<ForwardDetailBloc, ForwardDetailState>(
        listener: (context, state) {
          if (state.status == ForwardDetailStatus.failure) {
            BeaverToast.show(context, state.error ?? '加载失败');
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: state.title.isNotEmpty ? state.title : title,
            showBack: true,
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ForwardDetailState state) {
    if (state.status == ForwardDetailStatus.loading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF7D45)));
    }

    if (state.messages.isEmpty) {
      return const Center(
        child: Text('暂无聊天记录', style: TextStyle(color: Color(0xFFB2BEC3))),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.w),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        return _buildMessageRow(message);
      },
    );
  }

  Widget _buildMessageRow(MessageModel message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BeaverAvatar(avatar: message.avatar, size: 32),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.nickname ?? '用户',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFFB2BEC3),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.w),
                Container(
                  padding: message.type == MessageType.emoji
                      ? EdgeInsets.zero
                      : EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
                  decoration: message.type == MessageType.emoji
                      ? null
                      : BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                  child: _resolveMessageWidget(message),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _resolveMessageWidget(MessageModel message) {
    final m = message.msg;
    switch (message.type) {
      case MessageType.text:
        return TextMessage(
            msg: m.textMsg ?? TextMsg(content: ''), isSelf: false);
      case MessageType.image:
        return m.imageMsg == null ? const SizedBox() : ImageMessage(msg: m.imageMsg!);
      case MessageType.video:
        return m.videoMsg == null ? const SizedBox() : VideoMessage(msg: m.videoMsg!);
      case MessageType.audio:
        return m.audioFileMsg == null
            ? const SizedBox()
            : AudioMessage(msg: m.audioFileMsg!, isSelf: false);
      case MessageType.file:
        return m.fileMsg == null
            ? const SizedBox()
            : FileMessage(msg: m.fileMsg!, isSelf: false);
      case MessageType.emoji:
        return m.emojiMsg == null ? const SizedBox() : EmojiMessage(msg: m.emojiMsg!);
      default:
        return Text(message.content, style: const TextStyle(color: Color(0xFF2D3436)));
    }
  }
}
