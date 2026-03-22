import 'dart:io';
import 'package:flutter/material.dart';
import '../gallery/index.dart';

/// 底层傻瓜图片渲染组件 (对标原生 <img>)
/// 职责：只负责根据完整的 url (file:// 或 http://) 渲染图片
class BeaverImage extends StatelessWidget {
  final String url; // 保持 url 参数名，确保向后兼容性
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableFullscreen;

  const BeaverImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.enableFullscreen = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (url.isEmpty) {
      image = errorWidget ?? _buildDefaultError();
    } else if (url.startsWith('file://')) {
      final path = url.replaceFirst('file://', '');
      image = Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildDefaultError(),
      );
    } else if (url.startsWith('http')) {
      image = Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildDefaultPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildDefaultError(),
      );
    } else {
      image = errorWidget ?? _buildDefaultError();
    }

    if (enableFullscreen && url.isNotEmpty) {
      return GestureDetector(
        onTap: () => BeaverGallery.show(context, url),
        child: image,
      );
    }

    return image;
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
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
      width: width,
      height: height,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
    );
  }
}
