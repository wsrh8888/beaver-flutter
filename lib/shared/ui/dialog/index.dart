import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BeaverDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final String? contentText;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool showCancel;
  final Widget? child;
  final bool maskClosable;

  final Color? confirmColor;
  final Gradient? confirmGradient;

  const BeaverDialog({
    super.key,
    required this.title,
    this.content,
    this.contentText,
    this.confirmText = '确定',
    this.cancelText = '取消',
    required this.onConfirm,
    required this.onCancel,
    this.showCancel = true,
    this.child,
    this.maskClosable = true,
    this.confirmColor,
    this.confirmGradient,
  });

  static Color get maskColor => Colors.black.withOpacity(0.5);

  static SystemUiOverlayStyle get overlaySystemStyle =>
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      );

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Positioned(
      left: 0,
      right: 0,
      top: -topInset,
      bottom: -bottomInset,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlaySystemStyle,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: maskClosable ? onCancel : null,
            child: ColoredBox(
              color: maskColor,
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 280.w,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 24.w,
                          offset: Offset(0, 4.w),
                        ),
                      ],
                    ),
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D3436),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 16.w),
                      if (child != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.w),
                          child: Material(
                            color: Colors.transparent,
                            child: child!,
                          ),
                        )
                      else if (content != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.w),
                          child: Material(
                            color: Colors.transparent,
                            child: content!,
                          ),
                        )
                      else if (contentText != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.w),
                          child: Text(
                            contentText!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF636E72),
                              height: 1.5,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          if (showCancel)
                            Expanded(
                              child: GestureDetector(
                                onTap: onCancel,
                                child: Container(
                                  height: 40.w,
                                  margin: EdgeInsets.only(right: 12.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    cancelText,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF636E72),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: GestureDetector(
                              onTap: onConfirm,
                              child: Container(
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: confirmColor,
                                  gradient: confirmColor != null
                                      ? null
                                      : (confirmGradient ??
                                          const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFFFF7D45),
                                              Color(0xFFE86835),
                                            ],
                                          )),
                                  borderRadius: BorderRadius.circular(12.w),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  confirmText,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
