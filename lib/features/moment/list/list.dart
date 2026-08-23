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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/core/business/notification/inbox.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/store/notification/notification.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/features/moment/list/bloc/bloc.dart';
import 'package:beaver/features/moment/list/bloc/event.dart';
import 'package:beaver/features/moment/list/bloc/state.dart';
import 'package:beaver/types/api/moment.dart';
import 'package:beaver/shared/widgets/skeleton.dart';
import 'package:beaver/store/user/user.dart';
import 'package:beaver/store/contact/contact.dart';

class MomentListPage extends StatelessWidget {
  const MomentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MomentListBloc()..add(const LoadMomentListEvent(refresh: true)),
      child: const MomentListView(),
    );
  }
}

class MomentListView extends StatefulWidget {
  const MomentListView({super.key});

  @override
  State<MomentListView> createState() => _MomentListViewState();
}

class _MomentListViewState extends State<MomentListView> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<void>? _inboxSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _inboxSubscription =
        getIt<NotificationInboxBusiness>().inboxUpdateStream.listen((_) {
      if (!mounted) return;
      context.read<MomentListBloc>().add(
            const LoadMomentListEvent(refresh: true),
          );
    });
  }

  @override
  void dispose() {
    _inboxSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<MomentListBloc>();
      if (bloc.state.status == MomentListStatus.success && bloc.state.hasMore) {
        bloc.add(const LoadMomentListEvent());
      }
    }
  }

  String _formatTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 60) {
        return '${diff.inMinutes == 0 ? 1 : diff.inMinutes}分钟前';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}小时前';
      } else if (diff.inDays < 30) {
        return '${diff.inDays}天前';
      } else {
        return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      }
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '朋友圈',
      showHeader: true,
      showBack: true,
      showBackground: true,
      backgroundHeight: 120, // 375 standard
      isScrollable: false,
      child: Stack(
        children: [
          Container(
            color: const Color(0xFFF9FAFB),
            child: BlocBuilder<MomentListBloc, MomentListState>(
              builder: (context, state) {
                if (state.status == MomentListStatus.initial &&
                    state.moments.isEmpty) {
                  return const ListSkeleton();
                }

                if (state.status == MomentListStatus.error &&
                    state.moments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '加载失败',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF636E72),
                          ),
                        ),
                        SizedBox(height: 10.w),
                        GestureDetector(
                          onTap: () => context.read<MomentListBloc>().add(
                            const LoadMomentListEvent(refresh: true),
                          ),
                          child: Text(
                            '点击重试',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFFFF7D45),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFFFF7D45),
                  onRefresh: () async {
                    context.read<MomentListBloc>().add(
                      const LoadMomentListEvent(refresh: true),
                    );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: state.moments.length + 1 + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildHeader();
                      }
                      
                      final dataIndex = index - 1;
                      if (dataIndex >= state.moments.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.w),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final item = state.moments[dataIndex];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: _buildMomentItem(context, item),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Post Floating Button
          Positioned(
            right: 16.w,
            bottom: 30.w,
            child: GestureDetector(
              onTap: () async {
                final result = await context.push('/moment/post');
                if (result == true && mounted) {
                  context.read<MomentListBloc>().add(
                        const LoadMomentListEvent(refresh: true),
                      );
                }
              },
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.w),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7D45).withOpacity(0.3),
                      offset: Offset(0, 3.w),
                      blurRadius: 10.w,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(Icons.add, color: Colors.white, size: 24.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<UserStore, UserStoreState>(
      builder: (context, state) {
        final userInfo = context.watch<ContactStore>().getContact(state.currentUserId);

        return BlocBuilder<NotificationStore, NotificationStoreState>(
          builder: (context, notificationState) {
            final unreadCount = notificationState.momentUnread;

            return Container(
          margin: EdgeInsets.only(bottom: 24.w),
          height: 300.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 12.w,
                right: 12.w,
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.momentMessages),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(18.w),
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: -4.w,
                          top: -4.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: unreadCount > 9 ? 4.w : 5.w,
                              vertical: 2.w,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4757),
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            constraints: BoxConstraints(minWidth: 16.w),
                            child: Text(
                              unreadCount > 99 ? '99+' : '$unreadCount',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Cover
              Positioned.fill(
                bottom: 30.w,
                child: Container(
                   color: const Color(0xFFE86835),
                   child: const Center(child: Icon(Icons.image, color: Colors.white30, size: 48)),
                ),
              ),
              // User Info (Nickname & Avatar)
              Positioned(
                right: 16.w,
                bottom: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.w),
                      child: Text(
                        userInfo?.nickname ?? '我',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(1, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.w),
                        child: BeaverCachedImage(
                          fileUrl: userInfo?.avatar,
                          type: CacheType.avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
          },
        );
      },
    );
  }

  Future<void> _openMomentDetail(
    BuildContext context,
    IMomentListItem item, {
    String? replyCommentId,
  }) async {
    final query = replyCommentId == null || replyCommentId.isEmpty
        ? 'id=${item.id}'
        : 'id=${item.id}&replyCommentId=$replyCommentId';
    await context.push('${AppRoutes.momentDetail}?$query');
    if (mounted) {
      context.read<MomentListBloc>().add(
            const LoadMomentListEvent(refresh: true),
          );
    }
  }

  Widget _buildMomentItem(BuildContext context, IMomentListItem item) {
    final userState = context.watch<UserStore>().state;
    final contactStore = context.watch<ContactStore>();
    final currentUser = contactStore.getContact(userState.currentUserId);
    final currentUserId = userState.currentUserId;
    final currentUserName = currentUser?.nickname ?? '我';

    return GestureDetector(
      onTap: () => _openMomentDetail(context, item),
      child: Container(
      margin: EdgeInsets.only(bottom: 8.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: const Color(0xFFEBEEF5), width: 0.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: Offset(0, 1.w),
            blurRadius: 4.w,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.w),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  color: Colors.grey[200],
                  child: item.avatar?.isNotEmpty == true
                      ? BeaverCachedImage(
                          fileUrl: item.avatar!,
                          type: CacheType.avatar,
                          width: 32.w,
                          height: 32.w,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.person, color: Colors.grey[400]),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      _formatTime(item.createdAt),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFFB2BEC3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Content
          if (item.content.isNotEmpty) ...[
            SizedBox(height: 10.w),
            Text(
              item.content,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.5,
                color: const Color(0xFF2D3436),
              ),
            ),
          ],

          // Images
          if (item.files.isNotEmpty) ...[
            SizedBox(height: 10.w),
            _buildImagesGrid(item.files),
          ],

          // Actions
          SizedBox(height: 10.w),
          Row(
            children: [
              GestureDetector(
                onTap: () => _openMomentDetail(context, item),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 14.w,
                        color: const Color(0xFF636E72),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        item.commentCount > 0
                            ? '${item.commentCount}'
                            : '评论',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  context.read<MomentListBloc>().add(
                    ToggleLikeMomentEvent(
                      moment: item,
                      currentUserId: currentUserId,
                      currentUserName: currentUserName,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
                  decoration: BoxDecoration(
                    color: item.isLiked
                        ? const Color(0xFFFFE6D9)
                        : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 14.w,
                        color: item.isLiked
                            ? const Color(0xFFFF4757)
                            : const Color(0xFF636E72),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        item.likeCount > 0 ? '${item.likeCount}' : '赞',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: item.isLiked
                              ? const Color(0xFFFF4757)
                              : const Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (item.comments.isNotEmpty) ...[
            SizedBox(height: 8.w),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.comments.take(3).map((comment) {
                  final commentUser =
                      contactStore.getContact(comment.userId);
                  final name = commentUser?.nickname.isNotEmpty == true
                      ? commentUser!.nickname
                      : comment.userName;
                  return GestureDetector(
                    onTap: () => _openMomentDetail(
                      context,
                      item,
                      replyCommentId: comment.id,
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4.w),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: name,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF576B95),
                              ),
                            ),
                            TextSpan(
                              text: '：${comment.content}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Likes List
          if (item.likes.isNotEmpty) ...[
            SizedBox(height: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite, size: 10.w, color: Colors.grey[400]),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: item.likes.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final like = entry.value;
                          return TextSpan(
                            text:
                                like.userName +
                                (idx < item.likes.length - 1 ? '、' : ''),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFFF7D45),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
    );
  }

  Widget _buildImagesGrid(List<IMomentFileModel> files) {
    if (files.isEmpty) return const SizedBox.shrink();

    final displayFiles = files.length > 9 ? files.sublist(0, 9) : files;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = files.length == 1
            ? 1
            : (files.length == 2 || files.length == 4 ? 2 : 3);
        final runSpacing = 2.w;
        final spacing = 2.w;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: displayFiles.asMap().entries.map((entry) {
            final idx = entry.key;
            final file = entry.value;
            final isLast = idx == 8 && files.length > 9;

            return GestureDetector(
              onTap: () {
                // Image preview integration here
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.w),
                child: Container(
                  width: files.length == 1
                      ? constraints.maxWidth * 0.7
                      : itemWidth,
                  height: files.length == 1
                      ? constraints.maxWidth * 0.7
                      : itemWidth,
                  color: const Color(0xFFF8F9FA),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (file.type == 2)
                        BeaverCachedImage(
                          fileUrl: file.fileKey,
                          type: CacheType.image,
                          fit: BoxFit.cover,
                        )
                      else
                        Container(
                          color: const Color(0xFFF1F2F6),
                          child: Icon(
                            Icons.insert_drive_file_outlined,
                            color: const Color(0xFFB2BEC3),
                            size: 24.w,
                          ),
                        ),
                      if (isLast)
                        Container(
                          color: Colors.black.withOpacity(0.6),
                          alignment: Alignment.center,
                          child: Text(
                            '+${files.length - 9}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
