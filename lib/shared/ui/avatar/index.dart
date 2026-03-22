import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:flutter/material.dart';

class BeaverAvatar extends StatelessWidget {
  final String avatar;
  final double size;
  final VoidCallback? onTap;

  const BeaverAvatar({
    super.key,
    required this.avatar,
    this.size = 40.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BeaverCachedImage(
        fileKey: avatar,
        type: CacheType.avatar,
        width: size,
        height: size,
        borderRadius: size / 2,
        fit: BoxFit.cover,
      ),
    );
  }
}
