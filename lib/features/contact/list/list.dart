import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/contact/list/bloc/bloc.dart';
import 'package:beaver/features/contact/list/bloc/event.dart';
import 'package:beaver/features/contact/list/bloc/state.dart';
import 'package:beaver/features/contact/list/data/repositories/repository.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/core/database/database.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactListBloc(
        repository: ContactListRepository(getIt<AppDatabase>()),
      )..add(const LoadContactListEvent()),
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
    {'title': '新朋�?, 'icon': 'assets/icons/add-friend-icon.svg', 'route': '/new-friends'},
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                        fontSize: 28.w,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                    SizedBox(height: 20.w),
                    GestureDetector(
                      onTap: () {
                        context.read<ContactListBloc>().add(const LoadContactListEvent());
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

            return Stack(
              children: [
                // 内容区域
                Column(
                  children: [
                    // 顶部导航�?
                    _buildHeader(),
                    // 快捷操作�?
                    _buildQuickActions(),
                    // 联系人列�?
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.groupedContacts.length + 1, // +1 for the empty state
                        itemBuilder: (context, index) {
                          if (state.groupedContacts.isEmpty) {
                            return _buildEmptyState();
                          }

                          if (index >= state.groupedContacts.keys.length) {
                            return const SizedBox(height: 100); // 底部占位
                          }

                          final letter = state.indexList[index + 1]; // +1 because indexList starts with '�?
                          final contacts = state.groupedContacts[letter] ?? [];

                          return _buildContactSection(letter, contacts);
                        },
                      ),
                    ),
                  ],
                ),
                // 索引�?
                if (state.indexList.isNotEmpty)
                  _buildIndexBar(state.indexList, state.currentIndex),
              ],
            );
          },
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
            '好友',
            style: TextStyle(
              fontSize: 40.w,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(width: 48.w), // 占位，保持标题居�?
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _quickActions.map((action) {
          return GestureDetector(
            onTap: () => context.push(action['route'] as String),
            child: Column(
              children: [
                Container(
                  width: 96.w,
                  height: 96.w,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: Offset(0, 2.w),
                        blurRadius: 6.w,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    action['icon'] as String,
                    width: 48.w,
                    height: 48.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFF7D45),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(height: 8.w),
                Text(
                  action['title'] as String,
                  style: TextStyle(
                    fontSize: 24.w,
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
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey.withOpacity(0.1),
                width: 1.w,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                letter,
                style: TextStyle(
                  fontSize: 28.w,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF636E72),
                ),
              ),
              Text(
                '${contacts.length}',
                style: TextStyle(
                  fontSize: 24.w,
                  color: const Color(0xFFB2BEC3),
                ),
              ),
            ],
          ),
        ),
        // 联系人列�?
        Column(
          children: contacts.map((contact) {
            return GestureDetector(
              onTap: () => _handleContactTap(contact.userId),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.w),
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
                      url: contact.avatar,
                      name: contact.nickname,
                      size: 96.w,
                    ),
                    SizedBox(width: 32.w),
                    Expanded(
                      child: Text(
                        contact.notice ?? contact.nickname,
                        style: TextStyle(
                          fontSize: 32.w,
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
      right: 10.w,
      top: 50%,
      transform: Matrix4.translationValues(0, -indexList.length * 16.w, 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          children: indexList.map((letter) {
            return GestureDetector(
              onTap: () {
                context.read<ContactListBloc>().add(UpdateCurrentIndexEvent(letter));
                if (letter == '�?) {
                  _scrollToTop();
                }
              },
              child: Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 20.w,
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
            width: 120.w,
            height: 120.w,
            colorFilter: const ColorFilter.mode(
              Color(0xFFB2BEC3),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 24.w),
          Text(
            '暂无好友',
            style: TextStyle(
              fontSize: 32.w,
              color: const Color(0xFF636E72),
            ),
          ),
          SizedBox(height: 16.w),
          Text(
            '点击右上角添加好�?,
            style: TextStyle(
              fontSize: 24.w,
              color: const Color(0xFFB2BEC3),
            ),
          ),
        ],
      ),
    );
  }
}

