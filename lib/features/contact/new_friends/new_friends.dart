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
import 'package:beaver/features/contact/new_friends/bloc/bloc.dart';
import 'package:beaver/features/contact/new_friends/bloc/event.dart';
import 'package:beaver/features/contact/new_friends/bloc/state.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class NewFriendsPage extends StatelessWidget {
  const NewFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewFriendsBloc()..add(const LoadFriendRequestsEvent()),
      child: const NewFriendsView(),
    );
  }
}

class NewFriendsView extends StatelessWidget {
  const NewFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewFriendsBloc, NewFriendsState>(
      listener: (context, state) {
        if (state.status == NewFriendsStatus.error) {
          BeaverToast.show(context, state.errorMessage ?? '发生错误');
        }
      },
      builder: (context, state) {
        final filteredRequests = state.friendRequests.filterListByTab(state.activeTab);

        return BeaverLayout(
          title: '新的朋友',
          showBack: true,
          showHeader: true,
          isScrollable: false,
          child: Column(
            children: [
              _buildTabs(context, state),
              Expanded(
                child: state.status == NewFriendsStatus.loading && state.friendRequests.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : filteredRequests.isEmpty
                        ? _buildEmptyState(state.activeTab)
                        : _buildRequestList(context, filteredRequests),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabs(BuildContext context, NewFriendsState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFEBEEF5),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(
            context,
            title: '收到的申请',
            isActive: state.activeTab == 'received',
            onTap: () => context.read<NewFriendsBloc>().add(const SwitchTabEvent('received')),
            badgeCount: state.friendRequests.countPendingReceived(),
          ),
          _buildTabItem(
            context,
            title: '发出的申请',
            isActive: state.activeTab == 'sent',
            onTap: () => context.read<NewFriendsBloc>().add(const SwitchTabEvent('sent')),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required String title,
    required bool isActive,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52.w, // 104rpx / 2
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? const Color(0xFFFF7D45) : Colors.transparent,
                width: 3.w,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? const Color(0xFFFF7D45) : const Color(0xFF636E72),
                ),
              ),
              if (badgeCount > 0) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF5252), Color(0xFFE53935)],
                    ),
                    borderRadius: BorderRadius.circular(10.w),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5252).withValues(alpha: 0.3),
                        blurRadius: 8.w,
                        offset: Offset(0, 2.w),
                      ),
                    ],
                  ),
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestList(BuildContext context, List<FriendRequest> requests) {
    return ListView.builder(
      padding: EdgeInsets.all(12.w),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestItem(context, request);
      },
    );
  }

  Widget _buildRequestItem(BuildContext context, FriendRequest request) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.w,
            offset: Offset(0, 2.w),
          ),
        ],
      ),
      child: Row(
        children: [
          BeaverCachedImage(
            fileUrl: request.fileName,
            type: CacheType.avatar,
            width: 48.w,
            height: 48.w,
            borderRadius: 12.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        request.nickname,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3436),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (request.source.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7D45).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: Text(
                          _getSourceText(request.source),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFFFF7D45),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.w),
                Text(
                  request.message ?? '请求加为好友',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF636E72),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.w),
                Text(
                  request.createdAt,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFFB2BEC3),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _buildActions(context, request),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, FriendRequest request) {
    if (request.flag == 'receive') {
      if (request.status == 0) {
        return Row(
          children: [
            _buildActionButton(
              text: '接受',
              isPrimary: true,
              onTap: () => context.read<NewFriendsBloc>().add(AcceptRequestEvent(request.id)),
            ),
            SizedBox(width: 6.w),
            _buildActionButton(
              text: '拒绝',
              isPrimary: false,
              onTap: () => context.read<NewFriendsBloc>().add(RejectRequestEvent(request.id)),
            ),
          ],
        );
      } else {
        return _buildStatusBadge(request.status);
      }
    } else {
      return _buildStatusBadge(request.status, isSend: true);
    }
  }

  Widget _buildActionButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(colors: [Color(0xFFFF7D45), Color(0xFFE86835)])
              : null,
          color: isPrimary ? null : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12.w),
          border: isPrimary ? null : Border.all(color: const Color(0xFFEBEEF5)),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF7D45).withValues(alpha: 0.25),
                    blurRadius: 4.w,
                    offset: Offset(0, 1.w),
                  )
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : const Color(0xFF636E72),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int status, {bool isSend = false}) {
    String text;
    String icon;
    Color color;
    Color bgColor;

    if (status == 1) {
      text = '已添加';
      icon = 'assets/icons/new-friend/check-circle.svg';
      color = const Color(0xFFFF7D45);
      bgColor = const Color(0xFFFF7D45).withValues(alpha: 0.1);
    } else if (status == 2) {
      text = '已拒绝';
      icon = 'assets/icons/new-friend/close-circle.svg';
      color = const Color(0xFFFF5252);
      bgColor = const Color(0xFFFF5252).withValues(alpha: 0.1);
    } else {
      text = '等待验证';
      icon = 'assets/icons/new-friend/clock.svg';
      color = const Color(0xFFB2BEC3);
      bgColor = const Color(0xFFB2BEC3).withValues(alpha: 0.1);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon, width: 14.w, height: 14.w),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String activeTab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30.w,
                  offset: Offset(0, 8.w),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/new-friend/empty-friends.svg',
                width: 60.w,
                height: 60.w,
              ),
            ),
          ),
          SizedBox(height: 32.w),
          Text(
            '暂无${activeTab == 'received' ? '收到' : '发出'}的好友申请',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              activeTab == 'received' ? '当有人申请加你为好友时，会在这里显示' : '你发出的好友申请会在这里显示状态',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF636E72),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSourceText(String source) {
    const sourceMap = {
      'search': '搜索',
      'qrcode': '二维码',
      'group': '群聊',
      'card': '名片',
      'link': '链接',
      'other': '其他'
    };
    return sourceMap[source] ?? source;
  }
}

extension on List<FriendRequest> {
  List<FriendRequest> filterListByTab(String tab) {
    return where((r) => tab == 'received' ? r.flag == 'receive' : r.flag == 'send').toList();
  }

  int countPendingReceived() {
    return where((r) => r.flag == 'receive' && r.status == 0).length;
  }
}
