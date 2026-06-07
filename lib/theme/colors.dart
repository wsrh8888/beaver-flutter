import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF7D45);
  static const Color primaryDark = Color(0xFFE86835);
  static const Color background = Colors.white;
  static const Color inputBackground = Color(0xFFF9FAFB);
  static const Color textMain = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textPlaceholder = Color(0xFFB2BEC3);
  static const Color error = Color(0xFFFF7D45);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient topGradient = LinearGradient(
    colors: [Color(0x1AFF7D45), Color(0x00FFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 聊天页（对标微信）
  static const Color chatBackground = Color(0xFFEDEDED);
  static const Color chatBubbleSelf = primary;
  static const Color chatBubbleSelfText = Colors.white;
  static const Color chatBubbleOther = Color(0xFFFFFFFF);
  static const Color chatBubbleOtherText = Color(0xFF191919);
  static const Color chatBubbleOtherSubText = Color(0xFF888888);
  static const Color chatInputBackground = Color(0xFFF7F7F7);
}
