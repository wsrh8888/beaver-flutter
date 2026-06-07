import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/types/business/chat.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatListView();
  }
}

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '消息',
      showHeader: true,
      showBack: false,
      isScrollable: false,
      rightSlot: GestureDetector(
        onTap: () => _showTopMenu(context),
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
      child: BlocBuilder<ChatStore, ChatStoreState>(
        builder: (context, state) {
          final chats = state.conversations;
          final pinnedChats = chats.where((c) => c.isTop).toList();
          final regularChats = chats.where((c) => !c.isTop).toList();

          return CustomScrollView(
            slivers: [
              // 置顶会话
              if (pinnedChats.isNotEmpty) ...[
                _buildSectionHeader('置顶会话'),
                _buildPinnedList(pinnedChats),
              ],
              // 普通消息
              _buildSectionHeader('消息'),
              _buildRegularList(regularChats),
            ],
          );
        },
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

  Widget _buildPinnedList(List<ChatModel> pinnedChats) {
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
                    Badge(
                      label: chat.unreadCount > 0
                          ? Text(chat.unreadCount.toString())
                          : null,
                      isLabelVisible: chat.unreadCount > 0,
                      child: BeaverCachedImage(
                        fileUrl: chat.avatar,
                        type: CacheType.avatar,
                        width: 32.w,
                        height: 32.w,
                        borderRadius: 16.w,
                      ),
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

  Widget _buildRegularList(List<ChatModel> chats) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final chat = chats[index];
        return Slidable(
          key: Key(chat.conversationId),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  getIt<ChatStore>().togglePinChat(
                    chat.conversationId,
                    !chat.isTop,
                  );
                },
                backgroundColor: const Color(0xFFC7C7CC),
                foregroundColor: Colors.white,
                icon: chat.isTop
                    ? Icons.vertical_align_bottom
                    : Icons.vertical_align_top,
                label: chat.isTop ? '取消置顶' : '置顶',
              ),
              SlidableAction(
                onPressed: (context) => _handleDeleteChat(chat),
                backgroundColor: const Color(0xFFFF3B30),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: '移除',
              ),
            ],
          ),
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
                  Badge(
                    label: chat.unreadCount > 0
                        ? Text(chat.unreadCount.toString())
                        : null,
                    isLabelVisible: chat.unreadCount > 0,
                    child: BeaverCachedImage(
                      fileUrl: chat.avatar,
                      type: CacheType.avatar,
                      width: 48.w,
                      height: 48.w,
                      borderRadius: 24.w,
                    ),
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
                              chat.updatedAtStr,
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
      }, childCount: chats.length),
    );
  }

  void _showTopMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // Position the menu below the rightSlot (approximate)
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset(ScreenUtil().screenWidth - 10.w, 0),
          ancestor: overlay,
        ),
        button.localToGlobal(
          Offset(ScreenUtil().screenWidth, 0),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu<int>(
      context: context,
      position: position,
      color: const Color(0xFF2C2C2C), // True black-ish color
      surfaceTintColor: Colors.transparent, // Fix for M3 surface tint bug
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.w)),
      items: _homeMenus.map((menu) {
        return PopupMenuItem<int>(
          height: 48.w,
          value: menu['id'] as int,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                menu['icon'] as String,
                width: 20.w,
                height: 20.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                menu['title'] as String,
                style: TextStyle(
                  fontSize: 15.w,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    if (result != null) {
      _handleMenuClick(result);
    }
  }

  void _handleDeleteChat(ChatModel chat) async {
    final confirm = await showDialog<bool>(
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

    if (confirm == true) {
      getIt<ChatStore>().deleteChat(chat.conversationId);
      BeaverToast.show(context, '已删除');
    }
  }

  void _handleChatClick(ChatModel chat) {
    context.push('/chat/detail?id=${chat.conversationId}');
  }

  void _handleMenuClick(int id) {
    switch (id) {
      case 1: // 发起群聊
        context.push('/group/create');
        break;
      case 2: // 添加朋友
        context.push('/contact/search');
        break;
      case 3: // 扫一扫
        context.push(AppRoutes.scan);
        break;
    }
  }

  final List<Map<String, dynamic>> _homeMenus = [
    {'id': 1, 'title': '发起群聊', 'icon': 'assets/icons/dropdown-group-icon.svg'},
    {'id': 2, 'title': '添加朋友', 'icon': 'assets/icons/add-friend-icon.svg'},
    {'id': 3, 'title': '扫一扫', 'icon': 'assets/icons/scan-icon.svg'},
  ];
}
