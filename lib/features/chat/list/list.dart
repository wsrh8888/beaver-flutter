import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/chat/list/bloc/bloc.dart';
import 'package:beaver/features/chat/list/bloc/event.dart';
import 'package:beaver/features/chat/list/bloc/state.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatListBloc()..add(const LoadChatListEvent()),
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


  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '消息',
      showHeader: true,
      showBack: false,
      isScrollable: false,
      rightSlot: GestureDetector(
        onTap: () => setState(() => _showDropdown = !_showDropdown),
        child: Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFF7D45),
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/plus-icon.svg',
              width: 12.w,
              height: 12.w,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
      child: Stack(
        children: [
          BlocBuilder<ChatListBloc, ChatListState>(
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
                          fontSize: 14.w,
                          color: const Color(0xFF636E72),
                        ),
                      ),
                      SizedBox(height: 10.w),
                      GestureDetector(
                        onTap: () {
                          context.read<ChatListBloc>().add(const LoadChatListEvent());
                        },
                        child: Text(
                          '点击重试',
                          style: TextStyle(
                            fontSize: 14.w,
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
                  if (state.pinnedChats?.isNotEmpty == true) ...[
                    _buildSectionHeader('置顶会话'),
                    _buildPinnedList(state.pinnedChats!),
                  ],
                  // 普通消息
                  _buildSectionHeader('消息'),
                  _buildRegularList(state.chats ?? []),
                ],
              );
            },
          ),
          // 下拉菜单
          if (_showDropdown) ...[
            _buildDropdown(),
            _buildMask(),
          ],
        ],
      ),
    );
  }


  Widget _buildDropdown() {
    return Positioned(
      top: 60.w,
      right: 16.w,
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 2.w),
              blurRadius: 12.w,
            ),
          ],
        ),
        child: Column(
          children: _homeMenus.map((menu) {
            return GestureDetector(
              onTap: () => _handleMenuClick(menu['id'] as int),
              child: Container(
                height: 44.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: menu['id'] != _homeMenus.last['id']
                          ? Colors.grey.withOpacity(0.1)
                          : Colors.transparent,
                      width: 0.5.w,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      menu['icon'] as String,
                      width: 24.w,
                      height: 24.w,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF7D45),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      menu['title'] as String,
                      style: TextStyle(
                        fontSize: 14.w,
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
        padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 6.w),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.w,
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
        height: 60.w,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: pinnedChats.length,
          itemBuilder: (context, index) {
            final chat = pinnedChats[index];
            return GestureDetector(
              onTap: () => _handleChatClick(chat),
              child: Container(
                width: 200.w,
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      offset: Offset(0, 1.w),
                      blurRadius: 3.w,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    BeaverAvatar(
                      url: chat.avatar,
                      name: chat.nickname,
                      size: 32.w,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            chat.nickname,
                            style: TextStyle(
                              fontSize: 12.w,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.w),
                          Text(
                            chat.msgPreview,
                            style: TextStyle(
                              fontSize: 10.w,
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
              padding: EdgeInsets.only(right: 16.w),
              color: const Color(0xFFFF5252),
              child: Text(
                '删除',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.w,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('提示'),
                  content: const Text('确定删除该会话吗？'),
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
              BeaverToast.show(context, '已删除');
            },
            child: GestureDetector(
              onTap: () => _handleChatClick(chat),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFEBEEF5),
                      width: 0.5.w,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    BeaverAvatar(
                      url: chat.avatar,
                      name: chat.nickname,
                      size: 48.w,
                    ),
                    SizedBox(width: 16.w),
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
                                    fontSize: 16.w,
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
                                  fontSize: 12.w,
                                  color: const Color(0xFFB2BEC3),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.w),
                          Text(
                            chat.msgPreview,
                            style: TextStyle(
                              fontSize: 14.w,
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

  void _handleMenuClick(int id) {
    setState(() => _showDropdown = false);
    switch (id) {
      case 1: // 发起群聊
        context.push('/group/create');
        break;
      case 2: // 添加朋友
        context.push('/contact/search');
        break;
      case 3: // 扫一扫
        BeaverToast.show(context, '扫码功能开发中');
        break;
      case 4: // 收付款
        BeaverToast.show(context, '支付功能开发中');
        break;
    }
  }

  final List<Map<String, dynamic>> _homeMenus = [
    {'id': 1, 'title': '发起群聊', 'icon': 'assets/icons/dropdown-group-icon.svg'},
    {'id': 2, 'title': '添加朋友', 'icon': 'assets/icons/dropdown-friend-icon.svg'},
    {'id': 3, 'title': '扫一扫', 'icon': 'assets/icons/dropdown-scan-icon.svg'},
    {'id': 4, 'title': '收付款', 'icon': 'assets/icons/dropdown-pay-icon.svg'},
  ];
}
