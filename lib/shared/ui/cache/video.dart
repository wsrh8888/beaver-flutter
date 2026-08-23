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
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/cache/image.dart';

/// 业务层缓存视频组件 (对标 BeaverVideo.vue)
class BeaverCachedVideo extends StatefulWidget {
  final String? videoUrl;
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? borderRadius;
  final int? duration;
  final VoidCallback? onTap;

  const BeaverCachedVideo({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.duration,
    this.onTap,
  });

  @override
  State<BeaverCachedVideo> createState() => _BeaverCachedVideoState();
}

class _BeaverCachedVideoState extends State<BeaverCachedVideo> {
  @override
  Widget build(BuildContext context) {
    final content = Stack(
      alignment: Alignment.center,
      children: [
        BeaverCachedImage(
          fileUrl: widget.thumbnailUrl,
          type: CacheType.image,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          borderRadius: widget.borderRadius,
          errorWidget: _buildDefaultError(),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
        ),
        if (widget.duration != null && widget.duration! > 0)
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _formatDuration(widget.duration!),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
        ),
        clipBehavior: Clip.antiAlias,
        child: content,
      ),
    );
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildDefaultError() {
    return Container(
      color: Colors.grey[900],
      alignment: Alignment.center,
      child: const Icon(Icons.videocam_outlined, color: Colors.grey, size: 32),
    );
  }
}
