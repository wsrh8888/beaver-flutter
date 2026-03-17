import 'package:flutter/material.dart';
import 'package:beaver/shared/ui/image/image.dart';

class BeaverAvatar extends StatelessWidget {
  final String? url;
  final String? name;
  final String? nickname; // Alias for name
  final double size;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const BeaverAvatar({
    super.key,
    this.url,
    this.name,
    this.nickname,
    this.size = 40,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final String? displayName = name ?? nickname;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(size / 2),
      ),
      alignment: Alignment.center,
      child: url != null && url!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: BeaverImage(
                url: url!,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            )
          : Text(
              displayName?.isNotEmpty == true ? displayName![0].toUpperCase() : '?',
              style: textStyle ??
                  TextStyle(
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
    );
  }
}
