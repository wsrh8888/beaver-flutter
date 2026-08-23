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
import 'package:beaver/core/business/notification/moment_interaction.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/notification/notification.dart';
import 'package:beaver/types/business/moment_interaction.dart';
import 'package:beaver/types/cache.dart';

class MomentMessagesPage extends StatefulWidget {
  const MomentMessagesPage({super.key});

  @override
  State<MomentMessagesPage> createState() => _MomentMessagesPageState();
}

class _MomentMessagesPageState extends State<MomentMessagesPage> {
  final _business = MomentInteractionBusiness();
  final _inboxBusiness = getIt<NotificationInboxBusiness>();
  StreamSubscription<void>? _subscription;

  List<MomentInteractionItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _subscription = _inboxBusiness.inboxUpdateStream.listen((_) => _load());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationStore>().markCategoryAsViewed('moment');
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final userId = DatabaseManager.currentUserId;
    if (userId == null) return;

    setState(() => _loading = true);
    final items = await _business.getInteractions(userId);
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  String _formatTime(int timestamp) {
    if (timestamp <= 0) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes == 0 ? 1 : diff.inMinutes}分钟前';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    }
    if (diff.inDays < 30) {
      return '${diff.inDays}天前';
    }
    return '${dt.month}-${dt.day}';
  }

  void _openMoment(MomentInteractionItem item) {
    final query = item.commentId == null || item.commentId!.isEmpty
        ? 'id=${item.momentId}'
        : 'id=${item.momentId}&replyCommentId=${item.commentId}';
    context.push('${AppRoutes.momentDetail}?$query');
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '朋友圈消息',
      showBack: true,
      showHeader: true,
      isScrollable: false,
      child: _loading && _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: Text(
                    '暂无互动消息',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFFB2BEC3),
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFFFF7D45),
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: EdgeInsets.all(12.w),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.w),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return _buildItem(context, item);
                    },
                  ),
                ),
    );
  }

  Widget _buildItem(BuildContext context, MomentInteractionItem item) {
    final contact = context.watch<ContactStore>().getContact(item.fromUserId);
    final name = contact?.nickname.isNotEmpty == true
        ? contact!.nickname
        : '好友';
    final avatar = contact?.avatar;

    return GestureDetector(
      onTap: () => _openMoment(item),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(color: const Color(0xFFEBEEF5), width: 0.5.w),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.w),
              child: SizedBox(
                width: 44.w,
                height: 44.w,
                child: avatar?.isNotEmpty == true
                    ? BeaverCachedImage(
                        fileUrl: avatar,
                        type: CacheType.avatar,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.person, color: Colors.grey[400], size: 24.w),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF576B95),
                          ),
                        ),
                      ),
                      Text(
                        _formatTime(item.createdAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFFB2BEC3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    item.actionText,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                  if (item.content != null && item.content!.isNotEmpty) ...[
                    SizedBox(height: 4.w),
                    Text(
                      item.content!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF636E72),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.only(left: 6.w, top: 4.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4757),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
