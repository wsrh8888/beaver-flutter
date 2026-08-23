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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../gallery/index.dart';
import '../gallery/item.dart';

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
    } else if (url.startsWith('assets/')) {
      if (url.toLowerCase().endsWith('.svg')) {
        image = SvgPicture.asset(
          url,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
        );
      } else {
        image = Image.asset(
          url,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildDefaultError(),
        );
      }
    } else {
      image = errorWidget ?? _buildDefaultError();
    }

    if (enableFullscreen && url.isNotEmpty) {
      return GestureDetector(
        onTap: () => BeaverGallery.show(
          context,
          GalleryItem(url: url, type: GalleryItemType.image),
        ),
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
