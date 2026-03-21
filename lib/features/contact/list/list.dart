import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/contact/list/bloc/bloc.dart';
import 'package:beaver/features/contact/list/bloc/event.dart';
import 'package:beaver/features/contact/list/bloc/state.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class ContactListPage extends StatelessWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactListBloc()..add(const LoadContactListEvent()),
      child: const ContactListView(),
    );
  }
}

class ContactListView extends StatefulWidget {
  const ContactListView({super.key});

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _quickActions = [
    {'title': '新朋友', 'icon': 'assets/icons/add-friend-icon.svg', 'route': '/new-friends'},
    {'title': '群聊', 'icon': 'assets/icons/dropdown-group-icon.svg', 'route': '/group-list'},
    {'title': 'AI', 'icon': 'assets/icons/ai-icon.svg', 'route': '/ai'},
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleContactTap(String userId) {
    context.push('/detail/$userId');
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '好友',
      showHeader: true,
      showBack: false,
      isScrollable: false,
      child: BlocBuilder<ContactListBloc, ContactListState>(
        builder: (context, state) {
          if (state.status == ContactListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ContactListStatus.error) {
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
                      context.read<ContactListBloc>().add(const LoadContactListEvent());
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

          return Stack(
            children: [
              // 内容区域
              Column(
                children: [
                  // 快捷操作区
                  _buildQuickActions(),
                  // 联系人列表
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.groupedContacts.length + 1, // +1 for the empty state
                      itemBuilder: (context, index) {
                        if (state.groupedContacts.isEmpty) {
                          return _buildEmptyState();
                        }

                        if (index >= state.groupedContacts.keys.length) {
                          return const SizedBox(height: 50); // 底部占位
                        }

                        final letter = state.indexList[index + 1]; // +1 because indexList starts with '↑'
                        final contacts = state.groupedContacts[letter] ?? [];

                        return _buildContactSection(letter, contacts);
                      },
                    ),
                  ),
                ],
              ),
              // 索引栏
              if (state.indexList.isNotEmpty)
                _buildIndexBar(state.indexList, state.currentIndex),
            ],
          );
        },
      ),
    );
  }


  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _quickActions.map((action) {
          return GestureDetector(
            onTap: () => context.push(action['route'] as String),
            child: Column(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: Offset(0, 1.w),
                        blurRadius: 3.w,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    action['icon'] as String,
                    width: 24.w,
                    height: 24.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFF7D45),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  action['title'] as String,
                  style: TextStyle(
                    fontSize: 12.w,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactSection(String letter, List<dynamic> contacts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分组标题
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey.withOpacity(0.1),
                width: 0.5.w,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                letter,
                style: TextStyle(
                  fontSize: 14.w,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF636E72),
                ),
              ),
              Text(
                '${contacts.length}',
                style: TextStyle(
                  fontSize: 12.w,
                  color: const Color(0xFFB2BEC3),
                ),
              ),
            ],
          ),
        ),
        // 联系人列表
        Column(
          children: contacts.map((contact) {
            return GestureDetector(
              onTap: () => _handleContactTap(contact.userId),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
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
                    BeaverCachedImage(
                      fileKey: contact.avatar,
                      type: CacheType.avatar,
                      width: 48.w,
                      height: 48.w,
                      borderRadius: 24.w,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        contact.notice ?? contact.nickname,
                        style: TextStyle(
                          fontSize: 16.w,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D3436),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIndexBar(List<String> indexList, String currentIndex) {
    return Positioned(
      right: 5.w,
      top: 50.w,
      // transform: Matrix4.translationValues(0, -indexList.length * 8.w, 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Column(
          children: indexList.map((letter) {
            return GestureDetector(
              onTap: () {
                context.read<ContactListBloc>().add(UpdateCurrentIndexEvent(letter));
                if (letter == '↑') {
                  _scrollToTop();
                }
              },
              child: Container(
                width: 16.w,
                height: 16.w,
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 10.w,
                    fontWeight: currentIndex == letter ? FontWeight.w600 : FontWeight.w500,
                    color: currentIndex == letter ? const Color(0xFFFF7D45) : const Color(0xFF636E72),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/add-friend-icon.svg',
            width: 60.w,
            height: 60.w,
            colorFilter: const ColorFilter.mode(
              Color(0xFFB2BEC3),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 12.w),
          Text(
            '暂无好友',
            style: TextStyle(
              fontSize: 16.w,
              color: const Color(0xFF636E72),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '点击右上角添加好友',
            style: TextStyle(
              fontSize: 12.w,
              color: const Color(0xFFB2BEC3),
            ),
          ),
        ],
      ),
    );
  }
}
