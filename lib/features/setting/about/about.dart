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
import 'package:beaver/features/setting/about/bloc/bloc.dart';
import 'package:beaver/features/setting/about/bloc/event.dart';
import 'package:beaver/features/setting/about/bloc/state.dart';
import 'package:beaver/features/setting/about/data/repositories/repository.dart';
import 'package:beaver/features/setting/about/data/models/app_info.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late AboutBloc _aboutBloc;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _aboutBloc = AboutBloc(AboutRepository())..add(LoadAppInfoEvent());

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -10.w).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _aboutBloc.close();
    _floatController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _aboutBloc,
      child: BlocConsumer<AboutBloc, AboutState>(
        listener: (context, state) {
          if (state.status == AboutStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          }
        },
        builder: (context, state) {
          final appInfo =
              state.appInfo ??
              AppInfo(
                name: 'Beaver',
                version: '1.0.0',
                developer: 'Beaver Team',
                description:
                    'Beaver是一款致力于帮助用户拓展社交圈，发现志同道合朋友的即时通讯应用。我们相信真实的人际连接比以往任何时候都更加珍贵',
              );

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // 背景层
                _buildBackground(),

                // 装饰点
                _buildDecorativeDots(),

                // 主要内容
                SafeArea(
                  child: Column(
                    children: [
                      // 自定义导航栏
                      _buildNavbar(),

                      // 滚动内容
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10.w),
                              // 应用 Logo (带浮动动画)
                              AnimatedBuilder(
                                animation: _floatAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatAnimation.value),
                                    child: child,
                                  );
                                },
                                child: Container(
                                  width: 100.w, // 200rpx
                                  height: 100.w,
                                  margin: EdgeInsets.only(bottom: 32.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      38.w,
                                    ), // 76rpx
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFF7D45),
                                        Color(0xFFE86835),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFF7D45,
                                        ).withOpacity(0.3),
                                        offset: Offset(0, 12.w), // 24rpx
                                        blurRadius: 24.w, // 48rpx
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // 高光效果
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        height: 45.w,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(38.w),
                                              topRight: Radius.circular(38.w),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            38.w,
                                          ),
                                          child: Image.asset(
                                            'assets/images/logo.png',
                                            width: 60.w,
                                            height: 60.w,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // 应用名称
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    bottom: 2.w,
                                    left: -6.w,
                                    right: -6.w,
                                    height: 10.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE6D9),
                                        borderRadius: BorderRadius.circular(
                                          6.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    appInfo.name,
                                    style: TextStyle(
                                      fontSize: 32.sp, // 64rpx
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF2D3436),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.w), // 24rpx
                              // 版本号
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 6.w,
                                ), // 32rpx, 12rpx
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE6D9),
                                  borderRadius: BorderRadius.circular(
                                    20.w,
                                  ), // 40rpx
                                ),
                                child: Text(
                                  appInfo.version,
                                  style: TextStyle(
                                    fontSize: 16.sp, // 32rpx
                                    color: const Color(0xFFFF7D45),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.w), // 48rpx
                              // 关于文字 (富文本)
                              SizedBox(
                                width: 300.w, // 600rpx
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 17.sp, // 34rpx
                                      color: const Color(0xFF636E72),
                                      height: 1.8,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${appInfo.name}是一款致力于帮助用户',
                                      ),
                                      const TextSpan(
                                        text: '拓展社交圈',
                                        style: TextStyle(
                                          color: Color(0xFFE86835),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(text: '，发现'),
                                      const TextSpan(
                                        text: '志同道合',
                                        style: TextStyle(
                                          color: Color(0xFFE86835),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            '朋友的即时通讯应用。我们相信真实的人际连接比以往任何时候都更加珍贵。',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.w), // 80rpx
                              // 团队信息
                              Column(
                                children: [
                                  Text(
                                    '由',
                                    style: TextStyle(
                                      fontSize: 14.sp, // 28rpx
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                  ),
                                  SizedBox(height: 8.w), // 16rpx
                                  Text(
                                    appInfo.developer,
                                    style: TextStyle(
                                      fontSize: 18.sp, // 36rpx
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2D3436),
                                    ),
                                  ),
                                  SizedBox(height: 24.w), // 48rpx
                                  Text(
                                    '© 2025 版权所有',
                                    style: TextStyle(
                                      fontSize: 12.sp, // 24rpx
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                  ),
                                  SizedBox(height: 20.w), // 40rpx
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          // 渐变背景圆形 1
          Positioned(
            top: -160.w, // -320rpx
            right: -100.w, // -200rpx
            child: Container(
              width: 300.w, // 600rpx
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFF7D45).withOpacity(0.1),
                    const Color(0xFFE86835).withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          // 渐变背景圆形 2
          Positioned(
            bottom: -100.w, // -200rpx
            left: -100.w, // -200rpx
            child: Container(
              width: 200.w, // 400rpx
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFF7D45).withOpacity(0.1),
                    const Color(0xFFE86835).withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          // 图案纹理
          Positioned.fill(
            child: Opacity(opacity: 0.6, child: _TiledSvgBackground()),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeDots() {
    return Positioned.fill(
      child: Stack(
        children: [
          _buildDot(0.2, 0.1, 0.8),
          _buildDot(0.3, null, 0.5, right: 0.15),
          _buildDot(null, 0.2, 0.7, bottom: 0.25),
          _buildDot(null, null, 0.6, bottom: 0.15, right: 0.1),
        ],
      ),
    );
  }

  Widget _buildDot(
    double? top,
    double? left,
    double opacity, {
    double? bottom,
    double? right,
  }) {
    return Positioned(
      top: top != null ? ScreenUtil().screenHeight * top : null,
      left: left != null ? ScreenUtil().screenWidth * left : null,
      bottom: bottom != null ? ScreenUtil().screenHeight * bottom : null,
      right: right != null ? ScreenUtil().screenWidth * right : null,
      child: Container(
        width: 12.w, // 24rpx
        height: 12.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFE6D9).withOpacity(opacity),
        ),
      ),
    );
  }

  Widget _buildNavbar() {
    return Container(
      height: 56.w, // 112rpx
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: GestureDetector(
              onTap: _goBack,
              child: Container(
                width: 40.w, // 80rpx
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: Offset(0, 4.w), // 8rpx
                      blurRadius: 12.w, // 24rpx
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/common/arrow-left.svg',
                  width: 20.w, // 40rpx
                  height: 20.w,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF2D3436),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Text(
            '关于我们',
            style: TextStyle(
              fontSize: 18.sp, // 36rpx
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }
}

class _TiledSvgBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            for (double x = 0; x < constraints.maxWidth; x += 60.w)
              for (double y = 0; y < constraints.maxHeight; y += 60.w)
                Positioned(
                  left: x,
                  top: y,
                  child: SvgPicture.asset(
                    'assets/images/common/pattern.svg',
                    width: 60.w,
                    height: 60.w,
                  ),
                ),
          ],
        );
      },
    );
  }
}
