import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:beaver/common/ua/ua.dart';

/// 应用级配置 (Dart 规范化重构)
class AppConfig {
  static const String env = 'prod';
  static late String version;
  static late String deviceId;

  static const String source = 'beaver-flutter';

  /// 升级服务应用 ID，与后台默认种子及 Desktop 端一致
  static const String updateAppId = '87c9dc499cc34f32896a4537e66cf65e';

  /**
   * 生成标准 User-Agent
   */
  static String get userAgent => generateUserAgentIdentifier();

  static Future<void> init() async {
    await _initVersion();
    await _initDeviceId();
  }

  static Future<void> _initVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  static Future<void> _initDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor!;
    } else {
      throw UnsupportedError('Unsupported mobile platform');
    }
  }
}
