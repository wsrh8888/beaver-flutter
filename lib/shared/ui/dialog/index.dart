import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: maskClosable ? onCancel : null,
          child: Container(
            color: Colors.black.withOpacity(0.5), // uniapp rgba(0, 0, 0, 0.5)
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {}, // 防止点击对话框本身导致关闭
              child: Container(
                width: 280.w, // uniapp 560rpx
                padding: EdgeInsets.all(24.w), // uniapp 48rpx
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.w), // uniapp 40rpx
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
                    // 标题
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp, // 36rpx
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3436),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 16.w), // 32rpx

                    // 内容区域
                    if (child != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 24.w),
                        child: Material(child: child!, color: Colors.transparent),
                      )
                    else if (content != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 24.w),
                        child: Material(child: content!, color: Colors.transparent),
                      )
                    else if (contentText != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 24.w),
                        child: Text(
                          contentText!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp, // 28rpx
                            color: const Color(0xFF636E72),
                            height: 1.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),

                    // 按钮区域
                    Row(
                      children: [
                        if (showCancel)
                          Expanded(
                            child: GestureDetector(
                              onTap: onCancel,
                              child: Container(
                                height: 40.w, // 80rpx
                                margin: EdgeInsets.only(right: 12.w), // 24rpx
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12.w), // 24rpx
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  cancelText,
                                  style: TextStyle(
                                    fontSize: 14.sp, // 28rpx
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
                              height: 40.w, // 80rpx
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF7D45),
                                    Color(0xFFE86835),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.w), // 24rpx
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                confirmText,
                                style: TextStyle(
                                  fontSize: 14.sp, // 28rpx
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
    );
  }
}
