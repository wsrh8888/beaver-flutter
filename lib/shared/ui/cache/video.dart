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
  final int? duration;
  final VoidCallback? onTap;

  const BeaverCachedVideo({
    super.key,
    required this.videoKey,
    this.thumbnailKey,
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
  // 基础渲染：目前主要展示缩略图，点击播放逻辑通常在 handler 中
  @override
  Widget build(BuildContext context) {
    print('[BeaverCachedVideo] Build: videoKey=${widget.videoKey}, thumbnailKey=${widget.thumbnailKey}, width=${widget.width}, height=${widget.height}, duration=${widget.duration}');
    
    final content = Stack(
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
        // 播放按钮
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
        ),
        // 时长
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
      color: Colors.grey[900], // Darker background for error
      alignment: Alignment.center,
      child: const Icon(Icons.videocam_outlined, color: Colors.grey, size: 32),
    );
  }
}
