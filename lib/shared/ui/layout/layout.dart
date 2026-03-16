import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/core/theme/colors.dart';
import 'package:beaver/shared/widgets/beaver_header.dart';

class BeaverLayout extends StatelessWidget {
  final bool showHeader;
  final HeaderMode headerMode;
  final String? title;
  final bool showBack;
  final Color headerBackground;
  final bool showBackground;
  final double backgroundHeight;
  final Widget child;
  final bool isScrollable;
  final Widget? before;
  final Widget? after;
  final double beforeHeight;
  final double afterHeight;

  const BeaverLayout({
    super.key,
    this.showHeader = true,
    this.headerMode = HeaderMode.static,
    this.title,
    this.showBack = true,
    this.headerBackground = Colors.transparent,
    this.showBackground = false,
    this.backgroundHeight = 120, // 240rpx -> 120.w
    required this.child,
    this.isScrollable = true,
    this.before,
    this.after,
    this.beforeHeight = 0,
    this.afterHeight = 0,
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
                decoration: const BoxDecoration(
                  gradient: AppColors.topGradient,
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
                  showBack: showBack,
                  background: headerBackground,
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
