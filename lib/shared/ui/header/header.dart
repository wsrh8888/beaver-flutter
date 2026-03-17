import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beaver/core/theme/colors.dart';

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
    this.titleColor,
    this.leftIcon = 'assets/icons/common/arrow-back.svg',
    this.backButtonColor,
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
              alignment: Alignment.center,
              children: [
                // 左侧
                Positioned(
                  left: 0,
                  child: _buildLeft(context),
                ),
                // 中间标题
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 18.w,
                      fontWeight: FontWeight.bold,
                      color: titleColor ?? const Color(0xFF333333),
                    ),
                  ),
                // 右侧
                Positioned(
                  right: 0,
                  child: _buildRight(context),
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
      return GestureDetector(
        onTap: onBack ?? () => Navigator.maybePop(context),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: SvgPicture.asset(
            leftIcon,
            fit: BoxFit.contain,
            colorFilter: backButtonColor != null
                ? ColorFilter.mode(backButtonColor!, BlendMode.srcIn)
                : null,
          ),
        ),
      );
    }
    return SizedBox(width: 20.w);
  }

  Widget _buildRight(BuildContext context) {
    if (rightSlot != null) return rightSlot!;
    if (rightIcon != null) {
      return GestureDetector(
        onTap: onRightClick,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: SvgPicture.asset(rightIcon!, fit: BoxFit.contain),
        ),
      );
    }
    return SizedBox(width: 20.w);
  }

  @override
  Size get preferredSize => Size.fromHeight(44.w + ScreenUtil().statusBarHeight);
}
