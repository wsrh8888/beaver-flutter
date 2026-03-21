import 'dart:io';
import 'package:flutter/material.dart';

/// 底层傻瓜图片渲染组件 (对标原生 <img>)
/// 职责：只负责根据完整的 url (file:// 或 http://) 渲染图片
class BeaverImage extends StatelessWidget {
  final String url; // 保持 url 参数名，确保向后兼容性
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const BeaverImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return errorWidget ?? _buildDefaultError();
    }

    if (url.startsWith('file://')) {
      final path = url.replaceFirst('file://', '');
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildDefaultError(),
      );
    }

    if (url.startsWith('http')) {
      return Image.network(
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
    }

    // 适配其他资产图或纯相对路径（如果有的话）
    return errorWidget ?? _buildDefaultError();
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
