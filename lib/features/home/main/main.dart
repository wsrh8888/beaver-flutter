import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beaver/features/chat/list/list.dart';
import 'package:beaver/features/contact/list/list.dart';
import 'package:beaver/features/discover/main/main.dart';
import 'package:beaver/features/home/main/components/mine_drawer.dart';
import 'package:beaver/features/workbench/home/home.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/store/friend/friend_verify.dart';
import 'package:beaver/store/notification/notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 主界面底栏 Tab 索引。
/// 当前 4 段：消息 / 通讯录 / 工作台 / 发现。
/// 后续可扩展为 5 段，在中间插入 AI Tab。
enum HomeTab {
  chat(0),
  contact(1),
  workbench(2),
  discover(3);

  const HomeTab(this.tabIndex);
  final int tabIndex;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = HomeTab.chat.tabIndex;

  void _openMineDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  List<Widget> get _pages => [
        ChatListPage(onOpenProfile: _openMineDrawer),
        const ContactListPage(),
        const WorkbenchHomePage(),
        const DiscoverMainPage(),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatStore, ChatStoreState>(
      builder: (context, chatState) {
        return BlocBuilder<FriendVerifyStore, FriendVerifyStoreState>(
          builder: (context, verifyState) {
            return BlocBuilder<NotificationStore, NotificationStoreState>(
              builder: (context, notificationState) {
                return Scaffold(
                  key: _scaffoldKey,
                  drawer: Drawer(
                    width: MediaQuery.sizeOf(context).width * 0.85,
                    child: const MineDrawerPanel(),
                  ),
                  body: IndexedStack(
                    index: _currentIndex,
                    children: _pages,
                  ),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: BottomNavigationBar(
                      currentIndex: _currentIndex,
                      onTap: (index) {
                        setState(() => _currentIndex = index);
                      },
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.white,
                      selectedItemColor: const Color(0xFFFF7D45),
                      unselectedItemColor: const Color(0xFFB2BEC3),
                      selectedFontSize: 12.sp,
                      unselectedFontSize: 12.sp,
                      items: [
                        _buildNavItem(
                          '消息',
                          'new-chat.png',
                          'new-chat-active.png',
                          HomeTab.chat.tabIndex,
                          badgeCount: chatState.totalUnreadCount,
                        ),
                        _buildNavItem(
                          '通讯录',
                          'new-friend.png',
                          'new-friend-active.png',
                          HomeTab.contact.tabIndex,
                          badgeCount: verifyState.unreadCount,
                        ),
                        _buildSvgNavItem(
                          '工作台',
                          'assets/icons/tabbar/workbench.svg',
                          'assets/icons/tabbar/workbench-active.svg',
                          HomeTab.workbench.tabIndex,
                        ),
                        _buildSvgNavItem(
                          '发现',
                          'assets/icons/tabbar/discover.svg',
                          'assets/icons/tabbar/discover-active.svg',
                          HomeTab.discover.tabIndex,
                          badgeCount: notificationState.momentUnread,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem(
    String label,
    String iconName,
    String activeIconName,
    int index, {
    int badgeCount = 0,
  }) {
    return BottomNavigationBarItem(
      icon: Badge(
        label: badgeCount > 0 ? Text(badgeCount.toString()) : null,
        isLabelVisible: badgeCount > 0,
        child: Padding(
          padding: EdgeInsets.only(bottom: 4.w),
          child: Image.asset(
            'assets/icons/$iconName',
            width: 22.w,
            height: 22.w,
            color: _currentIndex == index ? null : const Color(0xFFB2BEC3),
          ),
        ),
      ),
      activeIcon: Badge(
        label: badgeCount > 0 ? Text(badgeCount.toString()) : null,
        isLabelVisible: badgeCount > 0,
        child: Padding(
          padding: EdgeInsets.only(bottom: 4.w),
          child: Image.asset(
            'assets/icons/$activeIconName',
            width: 22.w,
            height: 22.w,
          ),
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildSvgNavItem(
    String label,
    String iconPath,
    String activeIconPath,
    int index, {
    int badgeCount = 0,
  }) {
    final isActive = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Badge(
        label: badgeCount > 0 ? Text(badgeCount.toString()) : null,
        isLabelVisible: badgeCount > 0,
        child: Padding(
          padding: EdgeInsets.only(bottom: 4.w),
          child: SvgPicture.asset(
            iconPath,
            width: 22.w,
            height: 22.w,
            colorFilter: isActive
                ? null
                : const ColorFilter.mode(
                    Color(0xFFB2BEC3),
                    BlendMode.srcIn,
                  ),
          ),
        ),
      ),
      activeIcon: Badge(
        label: badgeCount > 0 ? Text(badgeCount.toString()) : null,
        isLabelVisible: badgeCount > 0,
        child: Padding(
          padding: EdgeInsets.only(bottom: 4.w),
          child: SvgPicture.asset(
            isActive ? activeIconPath : iconPath,
            width: 22.w,
            height: 22.w,
          ),
        ),
      ),
      label: label,
    );
  }
}
