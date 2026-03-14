import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'cache_config.dart';

/// 缓存图片组件
/// 
/// 基于 cached_network_image 实现
/// 支持占位图、错误图、加载进度
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final Map<String, String>? headers;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.headers,
  });

  @override
  Widget build(BuildContext context) {
    // 本地文件路径处理
    if (imageUrl.startsWith('file://') || imageUrl.startsWith('/')) {
      return Image.file(
        imageUrl.startsWith('file://') 
            ? imageUrl.substring(7) as dynamic
            : imageUrl as dynamic,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _defaultErrorWidget();
        },
      );
    }

    // 网络图片
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      httpHeaders: headers,
      placeholder: placeholder != null 
          ? (context, url) => placeholder!
          : (context, url) => _defaultPlaceholder(),
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!
          : (context, url, error) => _defaultErrorWidget(),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      maxWidthDiskCache: CacheConfig.imageMaxWidth,
      maxHeightDiskCache: CacheConfig.imageMaxHeight,
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Icon(
        Icons.broken_image,
        color: Colors.grey,
      ),
    );
  }
}

/// 圆形缓存头像
class CachedAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? fallbackText;
  final Color? backgroundColor;

  const CachedAvatar({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.fallbackText,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[400],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          fallbackText?.substring(0, 1).toUpperCase() ?? '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) {
      return fallback;
    }

    return ClipOval(
      child: CachedImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: fallback,
        errorWidget: fallback,
      ),
    );
  }
}
