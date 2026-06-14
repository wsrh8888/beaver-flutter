import 'dart:math';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiMessage extends StatelessWidget {
  final EmojiMsg msg;
  const EmojiMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    // 参考桌面端逻辑计算尺寸 (max: 120, min: 32)
    final double rawWidth = (msg.width ?? 64).toDouble();
    final double rawHeight = (msg.height ?? 64).toDouble();

    const double maxSize = 120.0;
    const double minSize = 32.0;

    double width = rawWidth;
    double height = rawHeight;

    if (width > maxSize || height > maxSize) {
      final double ratio = min(maxSize / width, maxSize / height);
      width = max(minSize, width * ratio);
      height = max(minSize, height * ratio);
    } else {
      width = max(minSize, width);
      height = max(minSize, height);
    }

    // 仅使用 BeaverCachedImage 渲染，由 fileUrl 决定内容同步
    return BeaverCachedImage(
      fileUrl: msg.fileUrl,
      width: width.w,
      height: height.w,
      fit: BoxFit.contain,
      borderRadius: 6.w,
      enableFullscreen: false,
    );
  }
}
