import 'package:flutter/material.dart';

class BeaverToast {
  static void show(
    BuildContext context,
    String message,
    {
      Duration duration = const Duration(seconds: 2),
      ToastType type = ToastType.info,
    }
  ) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 100,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getToastColor(type),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );

    overlay?.insert(entry);

    Future.delayed(duration, () {
      entry.remove();
    });
  }

  static Color _getToastColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return const Color(0xFFFF7D45);
      case ToastType.warning:
        return Colors.yellow;
      case ToastType.info:
      default:
        return Colors.grey;
    }
  }
}

enum ToastType {
  success,
  error,
  warning,
  info,
}
