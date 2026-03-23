import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/header/header.dart';

class BeaverLayout extends StatelessWidget {
  final bool showHeader;
  final HeaderMode headerMode;
  final String? title;
  final Color? titleColor;
  final bool showBack;
  final Color? backButtonColor;
  final Color headerBackground;
  final bool showBackground;
  final String backgroundType; // Match uniapp gradient | solid | none
  final double backgroundHeight;
  final Widget child;
  final Widget? before;
  final Widget? after;
  final double beforeHeight;
  final double afterHeight;
  final bool isScrollable;
  final String? leftIcon;
  final String? rightIcon;
  final Widget? leftSlot;
  final Widget? rightSlot;
  final VoidCallback? onBack;
  final VoidCallback? onRightClick;

  const BeaverLayout({
    super.key,
    this.showHeader = true,
    this.headerMode = HeaderMode.static,
    this.title,
    this.titleColor,
    this.showBack = true,
    this.backButtonColor,
    this.headerBackground = Colors.transparent,
    this.showBackground = false,
    this.backgroundType = 'gradient',
    this.backgroundHeight = 120, // 240rpx -> 120px
    required this.child,
    this.isScrollable = true,
    this.before,
    this.after,
    this.beforeHeight = 0,
    this.afterHeight = 0,
    this.leftIcon,
    this.rightIcon,
    this.leftSlot,
    this.rightSlot,
    this.onBack,
    this.onRightClick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      // 处理沉浸式状态栏：如果是 transparent 模式，内容延伸到状态栏
      extendBodyBehindAppBar: headerMode == HeaderMode.transparent,
      body: Stack(
        children: [
          // 1. 背景层 (background-layer)
          if (showBackground)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: backgroundHeight.w,
                decoration: BoxDecoration(
                  gradient: backgroundType == 'gradient'
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFFF7D45).withOpacity(0.1),
                            const Color(0xFFFFFFFF).withOpacity(0),
                          ],
                        )
                      : null,
                  color: backgroundType == 'solid' ? const Color(0xFFF8F9FA) : null,
                ),
              ),
            ),
          
          Column(
            children: [
              // 2. Header (PageHeader)
              if (showHeader)
                BeaverHeader(
                  mode: headerMode,
                  title: title,
                  titleColor: titleColor,
                  showBack: showBack,
                  backButtonColor: backButtonColor,
                  background: headerBackground,
                  leftIcon: leftIcon ?? 'assets/images/common/arrow-back.svg',
                  rightIcon: rightIcon,
                  leftSlot: leftSlot,
                  rightSlot: rightSlot,
                  onBack: onBack,
                  onRightClick: onRightClick,
                ),
              
              // 3. Before Content
              if (before != null)
                SizedBox(height: beforeHeight.w, child: before),
              
              // 4. Content (scroll-content)
              Expanded(
                child: isScrollable 
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: child,
                    )
                  : child,
              ),

              // 5. After Content
              if (after != null)
                SizedBox(height: afterHeight.w, child: after),
            ],
          ),
        ],
      ),
    );
  }
}
