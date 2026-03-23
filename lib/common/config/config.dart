import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// 应用级配置 (对标 desktop main/config)
class AppConfig {
  static String version = '1.0.0';
  static const String source = 'beaver-flutter';
  static String? _deviceId;

  static String get deviceId => _deviceId ?? 'unknown';

  static Future<void> init() async {
    if (_deviceId != null) return;
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor;
    } else {
      _deviceId = 'flutter-unknown-device';
    }
  }
}
