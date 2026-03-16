import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/list/bloc/bloc.dart';
import 'package:beaver/features/chat/list/bloc/event.dart';
import 'package:beaver/features/chat/list/bloc/state.dart';
import 'package:beaver/features/chat/list/data/repositories/repository.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/core/database/database.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatListBloc(
        repository: ChatListRepository(getIt<AppDatabase>()),
      )..add(const LoadChatListEvent()),
      child: const ChatListView(),
    );
  }
}

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  bool _showDropdown = false;

  final List<Map<String, dynamic>> _homeMenus = [
    {'id': 1, 'title': '添加好友', 'icon': 'assets/icons/add-friend-icon.svg'},
    {'id': 2, 'title': '创建群聊', 'icon': 'assets/icons/group-icon.svg'},
    {'id': 3, 'title': '扫一�?, 'icon': 'assets/icons/scan-icon.svg'},
  ];

  void _handleMenuClick(int id) {
    setState(() => _showDropdown = false);

    switch (id) {
      case 1:
        context.push('/search-friend');
        break;
      case 2:
        context.push('/create-group');
        break;
      case 3:
        _scanCode();
        break;
    }
  }

  void _scanCode() {
    // 实现扫码功能
    BeaverToast.show('扫码功能开发中...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 顶部导航�?
                _buildHeader(),
                // 内容区域
                Expanded(
                  child: BlocBuilder<ChatListBloc, ChatListState>(
                    builder: (context, state) {
                      if (state.status == ChatListStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == ChatListStatus.error) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.errorMessage ?? '加载失败',
                                style: TextStyle(
                                  fontSize: 28.w,
                                  color: const Color(0xFF636E72),
                                ),
                              ),
                              SizedBox(height: 20.w),
                              GestureDetector(
                                onTap: () {
                                  context.read<ChatListBloc>().add(const LoadChatListEvent());
                                },
                                child: Text(
                                  '点击重试',
                                  style: TextStyle(
                                    fontSize: 28.w,
                                    color: const Color(0xFFFF7D45),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return CustomScrollView(
                        slivers: [
                          // 置顶会话
                          if (state.pinnedChats.isNotEmpty) ...[
                            _buildSectionHeader('置顶会话'),
                            _buildPinnedList(state.pinnedChats),
                          ],
                          // 普通消�?
                          _buildSectionHeader('消息'),
                          _buildRegularList(state.chats),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            // 下拉菜单
            if (_showDropdown) ...[
              _buildDropdown(),
              _buildMask(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 112.w,
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '消息',
            style: TextStyle(
              fontSize: 40.w,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showDropdown = !_showDropdown),
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7D45),
                borderRadius: BorderRadius.circular(24.w),
              ),
              child: SvgPicture.asset(
                'assets/icons/plus-icon.svg',
                width: 24.w,
                height: 24.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Positioned(
      top: 120.w,
      right: 32.w,
      child: Container(
        width: 320.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 4.w),
              blurRadius: 24.w,
            ),
          ],
        ),
        child: Column(
          children: _homeMenus.map((menu) {
            return GestureDetector(
              onTap: () => _handleMenuClick(menu['id'] as int),
              child: Container(
                height: 88.w,
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: menu['id'] != _homeMenus.last['id']
                          ? Colors.grey.withOpacity(0.1)
                          : Colors.transparent,
                      width: 1.w,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      menu['icon'] as String,
                      width: 48.w,
                      height: 48.w,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF7D45),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Text(
                      menu['title'] as String,
                      style: TextStyle(
                        fontSize: 28.w,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMask() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showDropdown = false),
        child: Container(
          color: Colors.black.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(32.w, 24.w, 32.w, 12.w),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 28.w,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF636E72),
          ),
        ),
      ),
    );
  }

  Widget _buildPinnedList(List<dynamic> pinnedChats) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 120.w,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          itemCount: pinnedChats.length,
          itemBuilder: (context, index) {
            final chat = pinnedChats[index];
            return GestureDetector(
              onTap: () => _handleChatClick(chat),
              child: Container(
                width: 400.w,
                margin: EdgeInsets.only(right: 20.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(20.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      offset: Offset(0, 2.w),
                      blurRadius: 6.w,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    BeaverAvatar(
                      url: chat.avatar,
                      name: chat.nickname,
                      size: 64.w,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            chat.nickname,
                            style: TextStyle(
                              fontSize: 24.w,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.w),
                          Text(
                            chat.msgPreview,
                            style: TextStyle(
                              fontSize: 20.w,
                              color: const Color(0xFF636E72),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegularList(List<dynamic> chats) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final chat = chats[index];
          return Dismissible(
            key: Key(chat.conversationId),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 32.w),
              color: const Color(0xFFFF5252),
              child: Text(
                '删除',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.w,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('提示'),
                  content: const Text('确定删除该会话吗�?),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('确定'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              context.read<ChatListBloc>().add(
                DeleteChatEvent(conversationId: chat.conversationId),
              );
              BeaverToast.show('已删�?);
            },
            child: GestureDetector(
              onTap: () => _handleChatClick(chat),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFEBEEF5),
                      width: 1.w,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    BeaverAvatar(
                      url: chat.avatar,
                      name: chat.nickname,
                      size: 96.w,
                    ),
                    SizedBox(width: 32.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  chat.nickname,
                                  style: TextStyle(
                                    fontSize: 32.w,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2D3436),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                chat.updateAt,
                                style: TextStyle(
                                  fontSize: 24.w,
                                  color: const Color(0xFFB2BEC3),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.w),
                          Text(
                            chat.msgPreview,
                            style: TextStyle(
                              fontSize: 28.w,
                              color: const Color(0xFF636E72),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: chats.length,
      ),
    );
  }

  void _handleChatClick(dynamic chat) {
    context.push('/chat/${chat.conversationId}');
  }
}

