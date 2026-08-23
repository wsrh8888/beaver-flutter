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
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/types/cache.dart';

class CircleCommentSection extends StatelessWidget {
  final List<ICircleCommentItem> comments;
  final void Function(ICircleCommentItem comment) onReply;
  final void Function(ICircleCommentItem rootComment) onLoadMoreChildren;

  const CircleCommentSection({
    super.key,
    required this.comments,
    required this.onReply,
    required this.onLoadMoreChildren,
  });

  String _formatTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return '刚刚';
      if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
      if (diff.inHours < 24) return '${diff.inHours}小时前';
      if (diff.inDays < 30) return '${diff.inDays}天前';
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  String _getName(ContactStore contactStore, ICircleCommentItem comment) {
    final info = contactStore.getContact(comment.userId);
    return info?.nickname.isNotEmpty == true
        ? info!.nickname
        : comment.userName;
  }

  String? _getAvatar(ContactStore contactStore, ICircleCommentItem comment) {
    final info = contactStore.getContact(comment.userId);
    return info?.avatar ?? comment.avatar;
  }

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.w),
        child: Center(
          child: Text(
            '暂无评论',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
          ),
        ),
      );
    }

    final contactStore = context.read<ContactStore>();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 16.w),
      itemCount: comments.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.w),
      itemBuilder: (context, index) {
        final root = comments[index];
        final replies = root.children;
        final loadedCount = replies.length;
        final totalCount = root.childCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCommentItem(context, contactStore, root, showReplyTarget: false),
            if (replies.isNotEmpty)
              Container(
                margin: EdgeInsets.only(left: 44.w, top: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Column(
                  children: [
                    for (final reply in replies)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.w),
                        child: _buildCommentItem(
                          context,
                          contactStore,
                          reply,
                          showReplyTarget: true,
                          compact: true,
                        ),
                      ),
                  ],
                ),
              ),
            if (totalCount > loadedCount)
              Padding(
                padding: EdgeInsets.only(left: 44.w, top: 8.w),
                child: GestureDetector(
                  onTap: () => onLoadMoreChildren(root),
                  child: Text(
                    '展开更多回复',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF576B95),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    ContactStore contactStore,
    ICircleCommentItem comment, {
    required bool showReplyTarget,
    bool compact = false,
  }) {
    final name = _getName(contactStore, comment);
    final avatar = _getAvatar(contactStore, comment);
    final size = compact ? 28.0 : 36.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.w),
          child: BeaverCachedImage(
            fileUrl: avatar,
            type: CacheType.avatar,
            width: size.w,
            height: size.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF576B95),
                ),
              ),
              SizedBox(height: 4.w),
              Text.rich(
                TextSpan(
                  children: [
                    if (showReplyTarget && comment.replyToUserName.isNotEmpty)
                      TextSpan(
                        text: '回复 ${comment.replyToUserName}：',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF576B95),
                        ),
                      ),
                    TextSpan(
                      text: comment.content,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF2D3436),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6.w),
              Row(
                children: [
                  Text(
                    _formatTime(comment.createdAt),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFFB2BEC3),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  GestureDetector(
                    onTap: () => onReply(comment),
                    child: Text(
                      '回复',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
