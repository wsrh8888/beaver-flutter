import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/chat/chat_list/chat_list.dart';
import 'package:beaver/features/contact/pages/contact_page.dart';
import 'package:beaver/features/moment/pages/detail.dart';
import 'package:beaver/features/user/pages/profile.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/database/database.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatListPage(),
    const ContactPage(),
    const MomentPage(),
    const ProfilePage(),
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
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5)),
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
            _buildNavItem('朋友�?, 'moment.png', 'moment-active.png', 2),
            _buildNavItem('我的', 'new-mine.png', 'new-mine-active.png', 3),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            final db = getIt<AppDatabase>();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DriftDbViewer(db)),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('数据库未初始化，请重新登�? $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        backgroundColor: const Color(0xFFFF7D45),
        mini: true,
        child: const Icon(Icons.storage, color: Colors.white),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String label, String iconName, String activeIconName, int index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4.w),
        child: Image.asset(
          'assets/icons/$iconName',
          width: 22.w, // Match UniApp iconWidth: 22px
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

