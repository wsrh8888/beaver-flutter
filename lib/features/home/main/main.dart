import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/chat/list/list.dart';
import 'package:beaver/features/contact/list/list.dart';
import 'package:beaver/features/moment/list/list.dart';
import 'package:beaver/features/user/mine/mine.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatListPage(),
    const ContactListPage(),
    const MomentListPage(),
    const MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFFF7D45),
          unselectedItemColor: const Color(0xFFB2BEC3),
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          items: [
            _buildNavItem('消息', 'new-chat.png', 'new-chat-active.png', 0),
            _buildNavItem('好友', 'new-friend.png', 'new-friend-active.png', 1),
            _buildNavItem('朋友圈', 'moment.png', 'moment-active.png', 2),
            _buildNavItem('我的', 'new-mine.png', 'new-mine-active.png', 3),
          ],
        ),
      ),

    );
  }

  BottomNavigationBarItem _buildNavItem(String label, String iconName, String activeIconName, int index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4.w),
        child: Image.asset(
          'assets/icons/$iconName',
          width: 22.w, 
          height: 22.w,
          color: _currentIndex == index ? null : const Color(0xFFB2BEC3),
        ),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 4.w),
        child: Image.asset(
          'assets/icons/$activeIconName',
          width: 22.w,
          height: 22.w,
        ),
      ),
      label: label,
    );
  }
}
