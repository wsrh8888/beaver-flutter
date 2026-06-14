import 'dart:io';
import 'package:beaver/common/config/config.dart';

String _encodeUAToken(String value) {
  return Uri.encodeComponent(value);
}

/**
 * UA 构造：型号 + 系统版本 + 展示名
 * BeaverMobile/1.0.0 (ios; arm64) device_id/xxx model/iPhone17,3 os/18.2 name/iPhone%2017%20Pro
 */
String generateUserAgentIdentifier() {
  final version = AppConfig.version;
  final deviceId = AppConfig.deviceId;
  final platform = Platform.isIOS ? 'ios' : 'android';
  final arch = 'arm64';
  final model = AppConfig.deviceModel;
  final osVersion = AppConfig.deviceOsVersion;
  final name = AppConfig.deviceDisplayName;

  return 'BeaverMobile/$version ($platform; $arch) device_id/$deviceId model/${_encodeUAToken(model)} os/$osVersion name/${_encodeUAToken(name)}';
}

String _resolveIphoneName(String machine) {
  const names = <String, String>{
    'iPhone17,1': 'iPhone 17',
    'iPhone17,2': 'iPhone 17 Plus',
    'iPhone17,3': 'iPhone 17 Pro',
    'iPhone17,4': 'iPhone 17 Pro Max',
    'iPhone16,1': 'iPhone 15 Pro',
    'iPhone16,2': 'iPhone 15 Pro Max',
    'iPhone15,4': 'iPhone 15',
    'iPhone15,5': 'iPhone 15 Plus',
  };
  return names[machine] ?? machine;
}

Future<void> initDeviceProfile() async {
  final deviceInfo = AppConfig.deviceInfoPlugin;
  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    AppConfig.deviceModel = '${info.brand} ${info.model}';
    AppConfig.deviceOsVersion = info.version.release;
    AppConfig.deviceDisplayName = AppConfig.deviceModel;
    return;
  }
  if (Platform.isIOS) {
    final info = await deviceInfo.iosInfo;
    AppConfig.deviceModel = info.utsname.machine;
    AppConfig.deviceOsVersion = info.systemVersion;
    final resolved = _resolveIphoneName(info.utsname.machine);
    AppConfig.deviceDisplayName = resolved.isNotEmpty ? resolved : info.name;
  }
}
