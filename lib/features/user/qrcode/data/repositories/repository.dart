import 'package:beaver/features/user/qrcode/data/models/qrcode.dart';

class QrcodeRepository {
  Future<QrCodeData> getQrCodeData() async {
    // 模拟获取二维码数据
    await Future.delayed(const Duration(seconds: 1));
    return QrCodeData(
      userId: '123456',
      nickname: '张三',
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
    );
  }

  Future<bool> saveQrCode() async {
    // 模拟保存二维码
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
