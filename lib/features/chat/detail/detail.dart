import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/features/chat/detail/components/message_list.dart';
import 'package:beaver/features/chat/detail/components/input_bar.dart';
import 'package:beaver/features/chat/detail/data/repositories/repository.dart';
import 'package:beaver/features/chat/detail/data/models/types.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class ChatDetailPage extends StatefulWidget {
  final String? conversationId;

  const ChatDetailPage({
    super.key,
    this.conversationId,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    final database = DatabaseManager.instance;
    final repository = ChatRepository(database);
    _chatBloc = ChatBloc(repository);
    
    if (widget.conversationId != null) {
      _chatBloc.add(LoadMessagesEvent(widget.conversationId!));
    }
  }

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }

  void _handleSendMessage(String content, MessageType type) {
    _chatBloc.add(SendMessageEvent(content, type));
  }

  String _getDisplayTitle(ChatConversation? conversation) {
    return conversation?.title ?? '聊天';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatBloc,
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.status == ChatStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: _getDisplayTitle(state.conversation),
            showBack: true,
            isScrollable: false,
            child: Column(
              children: [
                Expanded(
                  child: MessageList(
                    messages: state.messages,
                    isLoadingMore: state.isLoadingMore,
                    onLoadMore: () => _chatBloc.add(const LoadMoreMessagesEvent()),
                  ),
                ),
                InputBar(
                  onSendMessage: _handleSendMessage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
