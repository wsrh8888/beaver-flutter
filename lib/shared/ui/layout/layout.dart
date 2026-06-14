import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/header/header.dart';
import 'package:beaver/shared/ui/ws_status/ws_status_bar.dart';
import 'package:beaver/shared/ui/dialog/index.dart';

class BeaverLayout extends StatelessWidget {
  final bool showHeader;
  final HeaderMode headerMode;
  final String? title;
  final Color? titleColor;
  final bool showBack;
  final Color? backButtonColor;
  final Color headerBackground;
  final bool statusBarIconLight;
  final bool showWsStatus;
  final bool showBackground;
  final String backgroundType;
  final double backgroundHeight;
  final Widget? fullScreenBackground;
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
  final Widget? overlay;

  const BeaverLayout({
    super.key,
    this.showHeader = true,
    this.headerMode = HeaderMode.static,
    this.title,
    this.titleColor,
    this.showBack = true,
    this.backButtonColor,
    this.headerBackground = const Color(0xFFFFFFFF),
    this.statusBarIconLight = false,
    this.showWsStatus = true,
    this.showBackground = false,
    this.backgroundType = 'gradient',
    this.backgroundHeight = 120,
    required this.child,
    this.isScrollable = true,
    this.before,
    this.after,
    this.beforeHeight = 0,
    this.afterHeight = 0,
    this.fullScreenBackground,
    this.leftIcon,
    this.rightIcon,
    this.leftSlot,
    this.rightSlot,
    this.onBack,
    this.onRightClick,
    this.overlay,
  });

  static SystemUiOverlayStyle overlaySystemStyle() {
    return BeaverDialog.overlaySystemStyle;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHeaderBg = headerBackground == Colors.transparent
        ? (fullScreenBackground != null
            ? Colors.transparent
            : const Color(0xFFFFFFFF))
        : headerBackground;
    final hasOverlay = overlay != null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: hasOverlay
          ? overlaySystemStyle()
          : SystemUiOverlayStyle(
              statusBarColor: effectiveHeaderBg,
              statusBarIconBrightness:
                  statusBarIconLight ? Brightness.light : Brightness.dark,
              statusBarBrightness:
                  statusBarIconLight ? Brightness.dark : Brightness.light,
            ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        extendBodyBehindAppBar:
            hasOverlay || headerMode == HeaderMode.transparent,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            if (fullScreenBackground != null)
              Positioned.fill(child: fullScreenBackground!),

            if (showBackground && fullScreenBackground == null)
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
                    color: backgroundType == 'solid'
                        ? const Color(0xFFF8F9FA)
                        : null,
                  ),
                ),
              ),

            Column(
              children: [
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
                if (showWsStatus) const WsStatusBar(),
                if (before != null)
                  SizedBox(height: beforeHeight.w, child: before),
                Expanded(
                  child: isScrollable
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: child,
                        )
                      : child,
                ),
                if (after != null)
                  SizedBox(height: afterHeight.w, child: after),
              ],
            ),
            if (overlay != null) overlay!,
          ],
        ),
      ),
    );
  }
}
