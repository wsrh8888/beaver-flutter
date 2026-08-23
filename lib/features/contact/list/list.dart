/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

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
import 'package:beaver/router/routes.dart';

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
    context.push('/contact/detail/userId'.replaceAll('userId', userId));
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '通讯录',
      showHeader: true,
      showBack: false,
      isScrollable: false,
      child: BlocBuilder<ContactListBloc, ContactListState>(
        builder: (context, state) {
          if (state.status == ContactListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              // 内容区域
              Column(
                children: [
                  // 快捷操作区
                  _buildQuickActions(state),
                  // 联系人列表
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.groupedContacts.length +
                          1, // +1 for the empty state
                      itemBuilder: (context, index) {
                        if (state.groupedContacts.isEmpty) {
                          return _buildEmptyState();
                        }

                        if (index >= state.groupedContacts.keys.length) {
                          return const SizedBox(height: 50); // 底部占位
                        }

                        final letter =
                            state.indexList[index +
                                1]; // +1 because indexList starts with '↑'
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

  Widget _buildQuickActions(ContactListState state) {
    return Column(
      children: [
        _buildActionRow(
          title: '新的朋友',
          icon: 'assets/icons/friend/new-friend.svg',
          route: AppRoutes.newFriends,
          badgeCount: state.friendRequestCount,
        ),
        _buildActionRow(
          title: '圈子',
          icon: 'assets/icons/friend/circle.svg',
          route: AppRoutes.circleList,
        ),
        _buildActionRow(
          title: '群通知',
          icon: 'assets/icons/common/message.svg',
          route: AppRoutes.groupNotifications,
          badgeCount: state.groupNotificationCount,
        ),
        _buildActionRow(
          title: '群聊',
          icon: 'assets/icons/friend/group-chat.svg',
          route: AppRoutes.groupList,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildActionRow({
    required String title,
    required String icon,
    required String route,
    int badgeCount = 0,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => context.push(route),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E8),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        icon,
                        width: 22.w,
                        height: 22.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFF7D45),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                  ),
                  if (badgeCount > 0)
                    Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5252),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Text(
                        badgeCount > 99 ? '99+' : badgeCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SvgPicture.asset(
                    'assets/icons/common/arrow-right.svg',
                    width: 16.w,
                    height: 16.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFB2BEC3),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1.w,
            indent: 68.w,
            color: const Color(0xFFEBEEF5),
          ),
      ],
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
                color: Colors.grey.withValues(alpha: 0.1),
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
                      fileUrl: contact.avatar,
                      type: CacheType.avatar,
                      width: 48.w,
                      height: 48.w,
                      borderRadius: 24.w,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        contact.notice?.isNotEmpty == true
                            ? contact.notice!
                            : contact.nickname,
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
          color: Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Column(
          children: indexList.map((letter) {
            return GestureDetector(
              onTap: () {
                context.read<ContactListBloc>().add(
                  UpdateCurrentIndexEvent(letter),
                );
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
                    fontWeight: currentIndex == letter
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: currentIndex == letter
                        ? const Color(0xFFFF7D45)
                        : const Color(0xFF636E72),
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
            style: TextStyle(fontSize: 16.w, color: const Color(0xFF636E72)),
          ),
          SizedBox(height: 8.w),
          Text(
            '点击右上角添加好友',
            style: TextStyle(fontSize: 12.w, color: const Color(0xFFB2BEC3)),
          ),
        ],
      ),
    );
  }
}
