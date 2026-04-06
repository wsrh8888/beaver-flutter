import 'package:flutter/material.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/core/business/index.dart';
import 'package:beaver/di/injection.dart';
import '../image/image.dart';

/// 业务层缓存图片组件 (对标 BeaverImage.vue)
/// 职责：拿到 fileKey -> 调用缓存层取地址 -> 使用 BeaverImage 底层渲染。
class BeaverCachedImage extends StatefulWidget {
  final String? fileKey;
  final CacheType type;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? borderRadius;
  final bool enableFullscreen;

  const BeaverCachedImage({
    super.key,
    required this.fileKey,
    this.type = CacheType.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.enableFullscreen = false,
  });

  @override
  State<BeaverCachedImage> createState() => _BeaverCachedImageState();
}

class _BeaverCachedImageState extends State<BeaverCachedImage> {
  String? _resolvedUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _resolveUrl();
  }

  @override
  void didUpdateWidget(BeaverCachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fileKey != widget.fileKey) {
      _resolveUrl();
    }
  }

  Future<void> _resolveUrl() async {
    final key = widget.fileKey;
    if (key == null || key.isEmpty) {
      if (mounted) {
        setState(() {
          _resolvedUrl = '';
          _isLoading = false;
        });
      }
      return;
    }

    if (mounted) setState(() => _isLoading = true);

    // 调用业务逻辑层获取完整地址
    final mediaBusiness = getIt<MediaBusiness>();
    final path = await mediaBusiness.getMediaPath(key, widget.type);

    if (mounted) {
      setState(() {
        _resolvedUrl = path;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? _buildDefaultLoading();
    }

    final double br = widget.borderRadius ?? 0;

    return Container(
      width: widget.width,
      height: widget.height,
      clipBehavior: br > 0 ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(br),
      ),
      child: BeaverImage(
        url: _resolvedUrl ?? '',
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        placeholder: widget.placeholder ?? _buildDefaultLoading(),
        errorWidget: widget.errorWidget ?? _buildDefaultError(),
        enableFullscreen: widget.enableFullscreen,
      ),
    );
  }

  Widget _buildDefaultLoading() {
    return Container(
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: Colors.grey, size: 24),
    );
  }
}
