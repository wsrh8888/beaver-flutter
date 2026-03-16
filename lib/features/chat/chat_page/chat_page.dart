import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/chat/chat_page/bloc/bloc.dart';
import 'package:beaver/features/chat/chat_page/bloc/event.dart';
import 'package:beaver/features/chat/chat_page/bloc/state.dart';
import 'package:beaver/features/chat/chat_page/components/message_list.dart';
import 'package:beaver/features/chat/chat_page/components/input_bar.dart';
import 'package:beaver/features/chat/chat_page/data/repositories/repository.dart';
import 'package:beaver/core/database/database.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;

  const ChatPage({
    super.key,
    required this.conversationId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatBloc _chatBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final database = AppDatabase.instance;
    final repository = ChatRepository(database);
    _chatBloc = ChatBloc(
      repository: repository,
      conversationId: widget.conversationId,
    )..add(LoadMessagesEvent(widget.conversationId));
  }

  @override
  void dispose() {
    _chatBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String content, MessageType type) {
    _chatBloc.add(SendMessageEvent(content, type));
  }

  void _handleLoadMore() {
    _chatBloc.add(LoadMoreMessagesEvent());
  }

  void _handleBack() {
    Navigator.of(context).pop();
  }

  void _handleClickMore() {
    // 这里可以根据聊天类型导航到不同的设置页面
  }

  String _getDisplayTitle(Conversation? conversation) {
    final nickname = conversation?.nickname ?? '';
    if (nickname.length >= 10) {
      return '${nickname.substring(0, 10)}...';
    }
    return nickname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 顶部渐变区域
          Container(
            height: 320.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x14FF7D45),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          BlocProvider.value(
            value: _chatBloc,
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state.status == ChatStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage ?? '发生错误')),
                  );
                }
              },
              builder: (context, state) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      // 头部导航
                      Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top,
                          left: 32.w,
                          right: 32.w,
                          bottom: 16.w,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _handleBack,
                                  child: Container(
                                    width: 64.w,
                                    height: 64.w,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 32.w,
                                      color: const Color(0xFF2D3436),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  _getDisplayTitle(state.conversation),
                                  style: TextStyle(
                                    fontSize: 36.w,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2D3436),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: _handleClickMore,
                              child: Container(
                                width: 72.w,
                                height: 72.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(36.w),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.more_vert,
                                  size: 32.w,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 聊天内容区域
                      Expanded(
                        child: MessageList(
                          messages: state.messages,
                          isLoadingMore: state.isLoadingMore,
                          onLoadMore: _handleLoadMore,
                        ),
                      ),
                      // 底部输入区域
                      InputBar(
                        onSendMessage: _handleSendMessage,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
