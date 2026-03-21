import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/theme/colors.dart';

enum HeaderMode { fixed, static, transparent }

class BeaverHeader extends StatelessWidget implements PreferredSizeWidget {
  final HeaderMode mode;
  final String? title;
  final Color? titleColor;
  final String leftIcon;
  final Color? backButtonColor;
  final String? rightIcon;
  final bool showBack;
  final Color background;
  final VoidCallback? onBack;
  final VoidCallback? onRightClick;
  final Widget? leftSlot;
  final Widget? rightSlot;

  const BeaverHeader({
    super.key,
    this.mode = HeaderMode.static,
    this.title,
    this.titleColor = const Color(0xFF333333), // Standard text color
    this.leftIcon =
        'assets/images/common/arrow-back.svg', // Final asset path from rule
    this.backButtonColor = const Color(0xFF333333), // Ensure visible by default
    this.rightIcon,
    this.showBack = true,
    this.background = Colors.transparent,
    this.onBack,
    this.onRightClick,
    this.leftSlot,
    this.rightSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 状态栏
          SizedBox(height: MediaQuery.of(context).padding.top),
          // Header 内容 (44px)
          Container(
            height: 44.w,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Stack(
              children: [
                // 1. 标题层 (居中，且不响应点击，防止遮挡按钮)
                if (title != null)
                  IgnorePointer(
                    child: Center(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          color: titleColor ?? const Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // 2. 交互层 (左右按钮)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildLeft(context), _buildRight(context)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeft(BuildContext context) {
    if (leftSlot != null) return leftSlot!;
    if (showBack) {
      return _HeaderButton(
        onTap: onBack ?? () => context.pop(),
        child: SvgPicture.asset(
          leftIcon,
          width: 20.w, // Match 40rpx / 2 = 20px
          height: 20.w,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            backButtonColor ?? const Color(0xFF333333),
            BlendMode.srcIn,
          ),
        ),
      );
    }
    return SizedBox(width: 44.w, height: 44.w); // Match uniapp placeholder
  }

  Widget _buildRight(BuildContext context) {
    if (rightSlot != null) return rightSlot!;
    if (rightIcon != null) {
      return _HeaderButton(
        onTap: onRightClick,
        child: SvgPicture.asset(
          rightIcon!,
          width: 20.w,
          height: 20.w,
          fit: BoxFit.contain,
        ),
      );
    }
    return SizedBox(width: 44.w, height: 44.w);
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(44.w + ScreenUtil().statusBarHeight);
}

// Micro-animation component matching uniapp &:active
class _HeaderButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _HeaderButton({required this.child, this.onTap});

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 44.w, // Sufficient hit area
        height: 44.w,
        alignment: Alignment.center,
        transform: _isPressed
            ? (Matrix4.identity()..scale(0.95))
            : Matrix4.identity(),
        child: Opacity(opacity: _isPressed ? 0.8 : 1.0, child: widget.child),
      ),
    );
  }
}
