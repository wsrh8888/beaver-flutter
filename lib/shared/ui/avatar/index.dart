import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';

class BeaverAvatar extends StatelessWidget {
  final String? avatar;
  final double size;
  final double? borderRadius;
  final VoidCallback? onTap;

  const BeaverAvatar({
    super.key,
    this.avatar,
    required this.size,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BeaverCachedImage(
        fileKey: avatar,
        type: CacheType.avatar,
        width: size.w,
        height: size.w,
        borderRadius: borderRadius ?? 8.w, // Default 8.w from AI 4.2 spec
        fit: BoxFit.cover,
      ),
    );
  }
}
