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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/types/cache.dart';

class CirclePostItem extends StatelessWidget {
  final ICirclePostItem post;
  final VoidCallback onLike;
  final VoidCallback? onTap;
  final VoidCallback? onComment;

  const CirclePostItem({
    super.key,
    required this.post,
    required this.onLike,
    this.onTap,
    this.onComment,
  });

  String _formatTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes == 0 ? 1 : diff.inMinutes}分钟前';
      }
      if (diff.inHours < 24) return '${diff.inHours}小时前';
      if (diff.inDays < 30) return '${diff.inDays}天前';
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(color: const Color(0xFFEBEEF5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BeaverAvatar(avatar: post.avatar, size: 36),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        _formatTime(post.createdAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (post.title.isNotEmpty) ...[
              SizedBox(height: 12.w),
              Text(
                post.title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ],
            if (post.content.isNotEmpty) ...[
              SizedBox(height: 8.w),
              Text(
                post.content,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.6,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ],
            if (post.files.any((f) => f.type == 2)) ...[
              SizedBox(height: 10.w),
              _buildImagesGrid(post.files),
            ],
            if (post.comments.isNotEmpty) ...[
              SizedBox(height: 10.w),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: post.comments.take(3).map((comment) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4.w),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: comment.userName,
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
                    );
                  }).toList(),
                ),
              ),
            ],
            SizedBox(height: 12.w),
            Divider(height: 1.w, color: const Color(0xFFEBEEF5)),
            SizedBox(height: 10.w),
            Row(
              children: [
                GestureDetector(
                  onTap: onLike,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        post.isLiked
                            ? 'assets/images/moment/like.svg'
                            : 'assets/images/moment/like-unliked.svg',
                        width: 16.w,
                        height: 16.w,
                        colorFilter: post.isLiked
                            ? const ColorFilter.mode(
                                Color(0xFFFF7D45),
                                BlendMode.srcIn,
                              )
                            : const ColorFilter.mode(
                                Color(0xFF636E72),
                                BlendMode.srcIn,
                              ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${post.likeCount}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: post.isLiked
                              ? const Color(0xFFFF7D45)
                              : const Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: onComment ?? onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 16.w,
                        color: const Color(0xFF636E72),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${post.commentCount}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesGrid(List<ICirclePostFile> files) {
    final images = files.where((f) => f.type == 2).toList();
    if (images.isEmpty) return const SizedBox.shrink();
    final display = images.length > 9 ? images.sublist(0, 9) : images;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = images.length == 1
            ? 1
            : (images.length == 2 || images.length == 4 ? 2 : 3);
        final spacing = 2.w;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: display.asMap().entries.map((entry) {
            final idx = entry.key;
            final file = entry.value;
            final isLast = idx == 8 && images.length > 9;
            return ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: SizedBox(
                width: images.length == 1
                    ? constraints.maxWidth * 0.7
                    : itemWidth,
                height: images.length == 1
                    ? constraints.maxWidth * 0.7
                    : itemWidth,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    BeaverCachedImage(
                      fileUrl: file.fileKey,
                      type: CacheType.image,
                      fit: BoxFit.cover,
                    ),
                    if (isLast)
                      Container(
                        color: Colors.black.withValues(alpha: 0.6),
                        alignment: Alignment.center,
                        child: Text(
                          '+${images.length - 9}',
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
            );
          }).toList(),
        );
      },
    );
  }
}
