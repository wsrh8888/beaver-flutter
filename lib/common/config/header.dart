import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:beaver/common/config/env.dart';
import 'package:beaver/shared/utils/storage_util.dart';

class HeaderConfig {
  static String? _deviceId;
  
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

  static Map<String, dynamic> getCommonParams() {
    final token = StorageUtil.getString('token');
    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);
    
    return {
      'source': 'beaver-flutter',
      'timestamp': timestamp,
      'env': currentEnv.name,
      'deviceId': _deviceId ?? 'unknown',
      if (token != null && token.isNotEmpty) 'token': token,
    };
  }
}
