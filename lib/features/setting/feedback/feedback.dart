/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/feedback/bloc/bloc.dart';
import 'package:beaver/features/setting/feedback/bloc/event.dart';
import 'package:beaver/features/setting/feedback/bloc/state.dart';
import 'package:beaver/features/setting/feedback/data/repositories/repository.dart';
import 'package:beaver/features/setting/feedback/data/models/feedback.dart';
import 'package:beaver/features/setting/feedback/data/constants.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late FeedbackBloc _feedbackBloc;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _feedbackBloc = FeedbackBloc(FeedbackRepository())..add(LoadFeedbackTypesEvent());
    _contentController.addListener(() {
      _feedbackBloc.add(UpdateContentEvent(_contentController.text));
    });
  }

  @override
  void dispose() {
    _feedbackBloc.close();
    _contentController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _selectFeedbackType(int type) {
    _feedbackBloc.add(SelectFeedbackTypeEvent(type));
  }

  void _chooseImage() {
    // 模拟选择图片
    final image = UploadedImage(
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=screenshot&size=512x512',
      name: 'screenshot.jpg',
    );
    _feedbackBloc.add(AddImageEvent(image));
  }

  void _removeImage(int index) {
    _feedbackBloc.add(RemoveImageEvent(index));
  }

  void _submitFeedback() {
    _feedbackBloc.add(SubmitFeedbackEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _feedbackBloc,
      child: BlocConsumer<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state.status == FeedbackStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          } else if (state.status == FeedbackStatus.success) {
            BeaverToast.show(context, '提交成功！');
            Future.delayed(const Duration(milliseconds: 1500), () {
              _goBack();
            });
          }
        },
        builder: (context, state) {
          final canSubmit = state.selectedType != null && state.content.trim().isNotEmpty;

          return BeaverLayout(
            title: '意见反馈',
            showBack: true,
            onBack: _goBack,
            showBackground: false,
            isScrollable: true,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 2.5.w), // 5rpx margin-top
                  // 主卡片
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.w), // 32rpx
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          offset: Offset(0, 4.w), // 8rpx
                          blurRadius: 16.w, // 32rpx
                        ),
                      ],
                      border: Border.all(
                        color: Colors.black.withOpacity(0.04),
                        width: 0.5.w, // 1rpx
                      ),
                    ),
                    padding: EdgeInsets.all(20.w), // 40rpx
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 反馈类型选择
                        Text(
                          '反馈类型',
                          style: TextStyle(
                            fontSize: 16.sp, // 32rpx
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        SizedBox(height: 12.w), // 24rpx
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 154 / 44, // based on gap and rpx
                          mainAxisSpacing: 10.w, // 20rpx
                          crossAxisSpacing: 10.w, // 20rpx
                          children: feedbackTypes.map((type) {
                            final isSelected = state.selectedType == type.value;
                            return GestureDetector(
                              onTap: () => _selectFeedbackType(type.value),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? const Color(0xFFFF7D45).withOpacity(0.1) 
                                      : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(10.w), // 20rpx
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFF7D45) : Colors.transparent,
                                    width: 1.w, // 2rpx
                                  ),
                                ),
                                child: Text(
                                  type.label,
                                  style: TextStyle(
                                    fontSize: 14.sp, // 28rpx
                                    color: isSelected ? const Color(0xFFFF7D45) : const Color(0xFF6C757D),
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 24.w), // 48rpx

                        // 问题描述
                        Text(
                          '问题描述',
                          style: TextStyle(
                            fontSize: 14.sp, // Vue has font-size: 14px for label
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        SizedBox(height: 4.w), // Vue has margin-bottom: 8px
                        Container(
                          height: 140.w, // 280rpx
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(10.w), // 20rpx
                            border: Border.all(
                              color: const Color(0xFFE9ECEF),
                              width: 1.w, // 2rpx
                            ),
                          ),
                          child: TextField(
                            controller: _contentController,
                            maxLines: null,
                            expands: true,
                            maxLength: 500,
                            style: TextStyle(
                              fontSize: 14.sp, // 28rpx
                              color: const Color(0xFF333333),
                            ),
                            decoration: InputDecoration(
                              hintText: '请详细描述您遇到的问题或建议...',
                              hintStyle: const TextStyle(color: Color(0xFFB2BEC3)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w), // 32rpx 28rpx
                              counterText: '',
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.w), // 16rpx
                            child: Text(
                              '${state.content.length}/500',
                              style: TextStyle(
                                fontSize: 12.sp, // 24rpx
                                color: const Color(0xFFB2BEC3),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.w), // upload-section gap

                        // 添加截图
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '添加截图',
                              style: TextStyle(
                                fontSize: 16.sp, // 32rpx
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                            Text(
                              '选填，最多3张',
                              style: TextStyle(
                                fontSize: 12.sp, // 24rpx
                                color: const Color(0xFFB2BEC3),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.w), // 24rpx
                        Wrap(
                          spacing: 12.w, // 24rpx
                          runSpacing: 12.w,
                          children: [
                            ...state.uploadedImages.asMap().entries.map((entry) {
                              final index = entry.key;
                              final image = entry.value;
                              return Container(
                                width: 90.w, // 180rpx
                                height: 90.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.w), // 20rpx
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      offset: Offset(0, 3.w), // 6rpx
                                      blurRadius: 10.w, // 20rpx
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.w),
                                      child: Image.network(
                                        image.fileName,
                                        width: 90.w,
                                        height: 90.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 6.w, // 12rpx
                                      right: 6.w,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
                                        child: Container(
                                          width: 22.w, // 44rpx
                                          height: 22.w,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.7),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.close,
                                            size: 14.w, // 28rpx font size equivalent
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            if (state.uploadedImages.length < 3)
                              GestureDetector(
                                onTap: _chooseImage,
                                child: Container(
                                  width: 90.w, // 180rpx
                                  height: 90.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(10.w),
                                    border: Border.all(
                                      color: const Color(0xFFDEE2E6),
                                      width: 1.w,
                                      style: BorderStyle.none, // actually vue says dashed
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: _DashedRectPainter(
                                      color: const Color(0xFFDEE2E6),
                                      strokeWidth: 1.w,
                                      borderRadius: 10.w,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/feedback/upload.svg',
                                          width: 24.w, // 48rpx
                                          height: 24.w,
                                          colorFilter: ColorFilter.mode(
                                            const Color(0xFF2D3436).withOpacity(0.6),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        SizedBox(height: 6.w), // 12rpx
                                        Text(
                                          '上传图片',
                                          style: TextStyle(
                                            fontSize: 12.sp, // 24rpx
                                            color: const Color(0xFFB2BEC3),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h), // spacing before button

                  // 提交按钮
                  GestureDetector(
                    onTap: canSubmit ? _submitFeedback : null,
                    child: Container(
                      width: double.infinity,
                      height: 48.w, // 96rpx
                      decoration: BoxDecoration(
                        gradient: canSubmit 
                            ? const LinearGradient(
                                colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: canSubmit ? null : const Color(0xFFCCCCCC),
                        borderRadius: BorderRadius.circular(24.w), // 48rpx
                        boxShadow: canSubmit 
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFFF7D45).withOpacity(0.3),
                                  offset: Offset(0, 6.w), // 12rpx
                                  blurRadius: 12.w, // 24rpx
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '提交反馈',
                        style: TextStyle(
                          fontSize: 16.sp, // 32rpx
                          fontWeight: FontWeight.w600,
                          color: canSubmit ? Colors.white : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;

  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final RRect rrect = ui.RRect.fromRectAndRadius(
      ui.Rect.fromLTWH(0, 0, size.width, size.height),
      ui.Radius.circular(borderRadius),
    );

    final ui.Path path = ui.Path()..addRRect(rrect);
    final ui.Path dashPath = ui.Path();

    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
