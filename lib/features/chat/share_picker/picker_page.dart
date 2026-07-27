import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/types/business/chat.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class ShareConversationPickerPage extends StatefulWidget {
  final Map<String, dynamic> payload;

  const ShareConversationPickerPage({
    super.key,
    required this.payload,
  });

  @override
  State<ShareConversationPickerPage> createState() =>
      _ShareConversationPickerPageState();
}

class _ShareConversationPickerPageState
    extends State<ShareConversationPickerPage> {
  String _query = '';
  bool _sending = false;

  List<ChatModel> _filtered(List<ChatModel> list) {
    final kw = _query.trim().toLowerCase();
    if (kw.isEmpty) return list;
    return list
        .where((c) => c.nickname.toLowerCase().contains(kw))
        .toList();
  }

  Future<void> _sendTo(ChatModel conversation) async {
    if (_sending) return;
    setState(() => _sending = true);

    try {
      final mode = widget.payload['mode'] as String? ?? 'card';
      MessageContentModel msg;

      if (mode == 'card' || mode == 'circleCard') {
        final cardType = widget.payload['cardType'] as int? ??
            (mode == 'circleCard' ? 3 : 0);
        final id = (widget.payload['id'] as String?) ??
            (widget.payload['circleId'] as String?) ??
            '';
        msg = MessageContentModel(
          type: MessageType.card,
          cardMsg: CardMsg(
            cardType: cardType,
            id: id,
            expireAt: (widget.payload['expireAt'] as int?) ?? 0,
          ),
        );
      } else if (mode == 'text') {
        msg = MessageContentModel(
          type: MessageType.text,
          textMsg: TextMsg(content: widget.payload['content'] as String? ?? ''),
        );
      } else {
        throw Exception('不支持的分享类型');
      }

      final chatType =
          conversation.conversationId.startsWith('group_') ? 'group' : 'private';

      await getIt<MessageBusiness>().sendMessage(
        ChatMessageSendBody(
          conversationId: conversation.conversationId,
          messageId: const Uuid().v4(),
          msg: msg,
          chatType: chatType,
        ),
      );

      if (!mounted) return;
      BeaverToast.show(context, '已发送');
      context.pop();
    } catch (e) {
      if (!mounted) return;
      BeaverToast.show(context, '发送失败');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '发送到',
      showBack: true,
      child: BlocBuilder<ChatStore, ChatStoreState>(
        builder: (context, state) {
          final list = _filtered(state.conversations);
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F2F6),
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search,
                          size: 20.w, color: const Color(0xFF99A3AD)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => _query = val),
                          decoration: const InputDecoration(
                            hintText: '搜索会话',
                            hintStyle: TextStyle(color: Color(0xFF99A3AD)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Text(
                          '暂无会话',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFB2BEC3),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return InkWell(
                            onTap: _sending ? null : () => _sendTo(item),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.w,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color(0xFFE9EDF2),
                                    width: 1.w,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  BeaverAvatar(avatar: item.avatar, size: 40),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      item.nickname,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 22.w,
                                    color: const Color(0xFFCBD2DA),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
