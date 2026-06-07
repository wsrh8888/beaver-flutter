import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/types/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageMessage extends StatelessWidget {
  final ImageMsg msg;
  const ImageMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final size = _calculateDisplaySize(
      (msg.width ?? 200).toDouble(),
      (msg.height ?? 200).toDouble(),
    );

    return BeaverCachedImage(
      fileUrl: msg.fileUrl,
      type: CacheType.image,
      width: size.width,
      height: size.height,
      borderRadius: 8.w,
      fit: BoxFit.cover,
    );
  }

  Size _calculateDisplaySize(double originalWidth, double originalHeight) {
    // 移动端适配：最大宽度限制为屏幕宽度的 60%
    final double maxWidth = 200.w;
    final double maxHeight = 300.w;

    if (originalWidth <= maxWidth && originalHeight <= maxHeight) {
      return Size(originalWidth, originalHeight);
    }

    final double widthRatio = maxWidth / originalWidth;
    final double heightRatio = maxHeight / originalHeight;
    final double scaleRatio = widthRatio < heightRatio ? widthRatio : heightRatio;

    return Size(originalWidth * scaleRatio, originalHeight * scaleRatio);
  }
}
