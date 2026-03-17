import 'package:flutter/material.dart';
import 'package:beaver/core/theme/colors.dart';

enum BeaverButtonType { filled, outline }

class BeaverButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool loading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BeaverButtonType type;

  const BeaverButton({
    super.key,
    required this.text,
    this.onPressed,
    this.disabled = false,
    this.loading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.borderRadius,
    this.type = BeaverButtonType.filled,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !disabled && !loading && onPressed != null;
    final isOutline = type == BeaverButtonType.outline;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: (isEnabled && !isOutline)
              ? (backgroundColor != null ? null : AppColors.primaryGradient)
              : null,
          color: isOutline 
              ? Colors.transparent 
              : (backgroundColor != null ? (isEnabled ? backgroundColor : Colors.grey[300]) : (isEnabled ? null : Colors.grey[300])),
          border: isOutline 
              ? Border.all(color: (isEnabled ? (backgroundColor ?? const Color(0xFFFF7D45)) : Colors.grey[300]!), width: 1) 
              : null,
          borderRadius: borderRadius ?? BorderRadius.circular(14),
          boxShadow: (isEnabled && !isOutline)
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF7D45).withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: isOutline ? (backgroundColor ?? const Color(0xFFFF7D45)) : (textColor ?? Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: isOutline 
                      ? (backgroundColor ?? const Color(0xFFFF7D45)) 
                      : (textColor ?? Colors.white),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
