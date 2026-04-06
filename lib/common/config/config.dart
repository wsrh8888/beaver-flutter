import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 应用级配置 (对标 desktop main/config)
class AppConfig {
  static String version = '1.0.0';
  static const String source = 'beaver-flutter';
  static String? _deviceId;

  static String get deviceId => _deviceId ?? 'unknown';

  static Future<void> init() async {
    // 1. 获取版本号
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
    } catch (_) {
      // 容错使用默认值 1.0.0
    }

    // 2. 获取设备 ID
    if (_deviceId != null) return;
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor;
      } else {
        _deviceId = 'flutter-unknown-device';
      }
    } catch (_) {
      _deviceId = 'unknown';
    }
  }
}
