import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:beaver/features/user/qrcode/bloc/bloc.dart';
import 'package:beaver/features/user/qrcode/bloc/event.dart';
import 'package:beaver/features/user/qrcode/bloc/state.dart';
import 'package:beaver/features/user/qrcode/data/repositories/repository.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class QrcodePage extends StatefulWidget {
  const QrcodePage({super.key});

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  late QrcodeBloc _qrcodeBloc;
  final GlobalKey _qrCodeKey = GlobalKey();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final database = AppDatabase.instance;
    final repository = QrcodeRepository(database);
    _qrcodeBloc = QrcodeBloc(repository)..add(LoadUserInfoEvent());
  }

  @override
  void dispose() {
    _qrcodeBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  String _getUserInitial(String? nickname) {
    if (nickname == null || nickname.isEmpty) return 'B';
    return nickname.substring(0, 1).toUpperCase();
  }

  Future<void> _handleSaveQrcode() async {
    setState(() => _isSaving = true);
    
    try {
      // 检查存储权限
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        _showToast('需要相册权限才能保存二维码');
        setState(() => _isSaving = false);
        return;
      }

      // 捕获二维码图片
      final boundary = _qrCodeKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // 保存到相册
      final result = await ImageGallerySaver.saveImage(pngBytes, quality: 100);
      
      if (result['isSuccess']) {
        _showToast('已保存到相册');
      } else {
        _showToast('保存失败，请重试');
      }
    } catch (e) {
      print('保存二维码失败: $e');
      _showToast('保存失败，请重试');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showToast(String message) {
    BeaverToast.show(context, message);
  }

  String _generateQrValue(String? userId) {
    final qrData = {
      'action': 'addFriend',
      'appName': 'Beaver',
      'version': '1.0.0',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expireAt': -1,
      'payload': {
        'userId': userId,
      },
    };
    return qrData.toString();
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
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF7D45),
                  Color(0xFFE86835),
                ],
              ),
            ),
            child: BeaverLayout(
              title: '我的二维码',
              titleColor: Colors.white,
              showBack: true,
              onBack: _goBack,
              backButtonColor: Colors.white,
              showBackground: false,
              isScrollable: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 二维码卡片
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(48.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: Offset(0, 40.w),
                            blurRadius: 80.w,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 卡片顶部
                          Container(
                            padding: EdgeInsets.all(48.w),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black.withOpacity(0.03),
                                  width: 2.w,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 96.w,
                                  height: 96.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32.w),
                                    color: const Color(0xFFFF7D45).withOpacity(0.1),
                                  ),
                                  child: state.userInfo.fileName != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(32.w),
                                          child: Image.network(
                                            state.userInfo.fileName!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            _getUserInitial(state.userInfo.nickname),
                                            style: TextStyle(
                                              fontSize: 40.w,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFFFF7D45),
                                            ),
                                          ),
                                        ),
                                ),
                                SizedBox(width: 32.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.userInfo.nickname ?? 'Beaver',
                                      style: TextStyle(
                                        fontSize: 36.w,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                    SizedBox(height: 8.w),
                                    Text(
                                      'ID: ${state.userInfo.userId ?? '未设置'}',
                                      style: TextStyle(
                                        fontSize: 20.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // 二维码主体
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 32.w, horizontal: 54.w),
                            color: const Color(0xFFFAFAFA),
                            child: RepaintBoundary(
                              key: _qrCodeKey,
                              child: Container(
                                width: 400.w,
                                height: 400.w,
                                padding: EdgeInsets.all(32.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      offset: Offset(0, 16.w),
                                      blurRadius: 48.w,
                                    ),
                                  ],
                                ),
                                child: QrImageView(
                                  data: _generateQrValue(state.userInfo.userId),
                                  version: QrVersions.auto,
                                  size: 336.w,
                                  gapless: false,
                                  embeddedImage: state.userInfo.fileName != null
                                      ? NetworkImage(state.userInfo.fileName!)
                                      : null,
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: Size(60.w, 60.w),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 卡片底部
                          Container(
                            padding: EdgeInsets.all(40.w),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black.withOpacity(0.03),
                                  width: 2.w,
                                ),
                              ),
                            ),
                            child: Text(
                              '扫一扫上面的二维码，添加我为好友',
                              style: TextStyle(
                                fontSize: 28.w,
                                color: const Color(0xFF636E72),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 60.w),

                    // 操作按钮
                    GestureDetector(
                      onTap: _isSaving ? null : _handleSaveQrcode,
                      child: Container(
                        width: 80.w * 10,
                        height: 88.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.w),
                          color: Colors.white.withOpacity(0.25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 8.w),
                              blurRadius: 24.w,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.download,
                              size: 32.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              '保存到相册',
                              style: TextStyle(
                                fontSize: 28.w,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 64.w),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
