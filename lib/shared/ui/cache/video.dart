import 'package:flutter/material.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/core/business/media/media.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/ui/cache/image.dart';

/// 业务层缓存视频组件 (对标 BeaverVideo.vue)
/// 职责：拿到 videoKey/thumbnailKey -> 调用缓存层取地址 -> 渲染缩略图 + 播放图标。
class BeaverCachedVideo extends StatefulWidget {
  final String? videoKey;
  final String? thumbnailKey;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? borderRadius;

  const BeaverCachedVideo({
    super.key,
    required this.videoKey,
    this.thumbnailKey,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<BeaverCachedVideo> createState() => _BeaverCachedVideoState();
}

class _BeaverCachedVideoState extends State<BeaverCachedVideo> {
  // 基础渲染：目前主要展示缩略图，点击播放逻辑通常在 handler 中
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BeaverCachedImage(
          fileKey: widget.thumbnailKey,
          type: CacheType.image,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          borderRadius: widget.borderRadius,
          errorWidget: _buildDefaultError(),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  Widget _buildDefaultError() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.videocam_outlined, color: Colors.grey, size: 32),
    );
  }
}
