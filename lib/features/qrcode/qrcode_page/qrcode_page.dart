import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/qrcode/qrcode_page/bloc/bloc.dart';
import 'package:beaver/features/qrcode/qrcode_page/bloc/event.dart';
import 'package:beaver/features/qrcode/qrcode_page/bloc/state.dart';
import 'package:beaver/features/qrcode/qrcode_page/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';

class QrcodePage extends StatefulWidget {
  const QrcodePage({super.key});

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  late QrcodeBloc _qrcodeBloc;

  @override
  void initState() {
    super.initState();
    _qrcodeBloc = QrcodeBloc(QrcodeRepository())..add(LoadQrCodeEvent());
  }

  @override
  void dispose() {
    _qrcodeBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _saveQrCode() {
    _qrcodeBloc.add(SaveQrCodeEvent());
  }

  String _getUserInitial(String nickname) {
    return nickname.isNotEmpty ? nickname[0].toUpperCase() : 'B';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _qrcodeBloc,
      child: BlocConsumer<QrcodeBloc, QrcodeState>(
        listener: (context, state) {
          if (state.status == QrcodeStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          } else if (state.errorMessage != null && state.status != QrcodeStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final qrCodeData = state.qrCodeData;

          return BeaverLayout(
            title: '我的二维码',
            showBack: true,
            showBackground: true,
            backgroundType: 'gradient',
            backgroundHeight: 300.w,
            isScrollable: true,
            child: Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // 二维码卡片
                  Container(
                    margin: EdgeInsets.only(bottom: 24.w),
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          offset: Offset(0, 4.w),
                          blurRadius: 12.w,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 卡片顶部
                        if (qrCodeData != null)
                          Container(
                            margin: EdgeInsets.only(bottom: 24.w),
                            child: Row(
                              children: [
                                BeaverAvatar(
                                  url: qrCodeData.fileName,
                                  size: 64.w,
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        qrCodeData.nickname,
                                        style: TextStyle(
                                          fontSize: 18.w,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2D3436),
                                        ),
                                      ),
                                      SizedBox(height: 4.w),
                                      Text(
                                        'ID: ${qrCodeData.userId}',
                                        style: TextStyle(
                                          fontSize: 14.w,
                                          color: const Color(0xFFB2BEC3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // 卡片主体
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          child: Container(
                            width: 200.w,
                            height: 200.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.w),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                                width: 1.w,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.qr_code_2,
                              size: 160.w,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // 卡片底部
                        Text(
                          '扫一扫上面的二维码，添加我为好友',
                          style: TextStyle(
                            fontSize: 14.w,
                            color: const Color(0xFF636E72),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // 操作按钮
                  GestureDetector(
                    onTap: _saveQrCode,
                    child: Container(
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(24.w),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download,
                            size: 20.w,
                            color: const Color(0xFF2D3436),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '保存到相册',
                            style: TextStyle(
                              fontSize: 16.w,
                              color: const Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
