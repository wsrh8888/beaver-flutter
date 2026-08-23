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

import 'package:beaver/common/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:beaver/features/user/qrcode/bloc/bloc.dart';
import 'package:beaver/features/user/qrcode/bloc/event.dart';
import 'package:beaver/features/user/qrcode/bloc/state.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/utils/media_util.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QrcodePage extends StatefulWidget {
  const QrcodePage({super.key});

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  late QrcodeBloc _qrcodeBloc;
  final GlobalKey _qrCodeKey = GlobalKey();
  bool _isSaving = false;
  String? _qrValue;
  String? _qrValueUserId;

  static const _pageGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFF7D45),
        Color(0xFFE86835),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    _qrcodeBloc = QrcodeBloc()..add(const LoadQrCodeEvent());
  }

  @override
  void dispose() {
    _qrcodeBloc.close();
    super.dispose();
  }

  Future<void> _handleSaveQrcode() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final hasPermission = await requestGallerySavePermission(context);
    if (!hasPermission) {
      if (mounted) setState(() => _isSaving = false);
      return;
    }

    final boundary =
        _qrCodeKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      _showToast('保存失败，请重试');
      if (mounted) setState(() => _isSaving = false);
      return;
    }

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      _showToast('保存失败，请重试');
      if (mounted) setState(() => _isSaving = false);
      return;
    }

    final success = await ImageGallerySaverPlus.saveImage(
      byteData.buffer.asUint8List(),
      quality: 100,
    );

    if (success != null && success['isSuccess'] == true) {
      _showToast('已保存到相册');
    } else {
      _showToast('保存失败，请重试');
    }

    if (mounted) setState(() => _isSaving = false);
  }

  void _showToast(String message) {
    if (mounted) BeaverToast.show(context, message);
  }

  String _qrValueFor(String? userId) {
    if (userId == null || userId.isEmpty) return '';
    if (_qrValue != null && _qrValueUserId == userId) return _qrValue!;

    _qrValueUserId = userId;
    _qrValue = jsonEncode({
      'action': 'addFriend',
      'appName': 'beaver',
      'version': AppConfig.version,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expireAt': 0,
      'payload': {
        'userId': userId,
      },
    });
    return _qrValue!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _qrcodeBloc,
      child: BlocConsumer<QrcodeBloc, QrcodeState>(
        listener: (context, state) {
          if (state.status == QrcodeStatus.error) {
            _showToast(state.errorMessage ?? '发生错误');
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '我的二维码',
            titleColor: Colors.white,
            showBack: true,
            backButtonColor: Colors.white,
            headerBackground: Colors.transparent,
            statusBarIconLight: true,
            showWsStatus: false,
            fullScreenBackground: const DecoratedBox(decoration: _pageGradient),
            isScrollable: false,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: BottomDecorationClipper(),
                    child: Container(
                      height: 100.w,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.w,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: Offset(0, 20.w),
                                blurRadius: 40.w,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(24.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black.withOpacity(0.03),
                                      width: 0.5.w,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    BeaverCachedImage(
                                      fileUrl: state.qrCodeData?.fileName,
                                      type: CacheType.avatar,
                                      width: 48.w,
                                      height: 48.w,
                                      borderRadius: 16.w,
                                    ),
                                    SizedBox(width: 16.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.qrCodeData?.nickname ??
                                              'beaver',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF2D3436),
                                          ),
                                        ),
                                        SizedBox(height: 4.w),
                                        Text(
                                          'ID: ${state.qrCodeData?.userId ?? '未设置'}',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: const Color(0xFF636E72),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.w,
                                  horizontal: 27.w,
                                ),
                                color: const Color(0xFFFAFAFA),
                                child: RepaintBoundary(
                                  key: _qrCodeKey,
                                  child: Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.08),
                                          offset: Offset(0, 8.w),
                                          blurRadius: 24.w,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        QrImageView(
                                          data: _qrValueFor(
                                            state.qrCodeData?.userId,
                                          ),
                                          version: QrVersions.auto,
                                          size: 168.w,
                                          gapless: false,
                                          errorCorrectionLevel:
                                              QrErrorCorrectLevel.M,
                                        ),
                                        if (state.qrCodeData?.fileName !=
                                                null &&
                                            state.qrCodeData!.fileName
                                                .isNotEmpty)
                                          Container(
                                            width: 30.w,
                                            height: 30.w,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6.w),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.w,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6.w),
                                              child: BeaverCachedImage(
                                                fileUrl: state
                                                    .qrCodeData!.fileName,
                                                type: CacheType.avatar,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.black.withOpacity(0.03),
                                      width: 0.5.w,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '扫一扫上面的二维码，添加我为好友',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF636E72),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.w),
                        GestureDetector(
                          onTap: _isSaving ? null : _handleSaveQrcode,
                          child: Container(
                            width: 300.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.w),
                              color: Colors.white.withOpacity(0.25),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/common/download.svg',
                                  width: 16.w,
                                  height: 16.w,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  _isSaving ? '保存中...' : '保存到相册',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BottomDecorationClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height),
      width: size.width * 1.4,
      height: size.height * 1.2,
    );
    path.addOval(rect);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
