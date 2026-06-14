import 'dart:io';
import 'package:beaver/common/config/config.dart';

String _encodeUAToken(String value) {
  return Uri.encodeComponent(value);
}

String _normalizeModelToken(String value) {
  return value.trim().replaceAll(RegExp(r'\s+'), '-');
}

/**
 * UA 构造：对标 desktop，型号不 encode，展示名 encode
 * BeaverMobile/2.0.1 (ios; arm64) device_id/xxx model/iPhone17,3 os/18.2 name/My-iPhone
 */
String generateUserAgentIdentifier() {
  final version = AppConfig.version;
  final deviceId = AppConfig.deviceId;
  final platform = Platform.isIOS ? 'ios' : 'android';
  final arch = AppConfig.deviceArch;
  final model = _normalizeModelToken(
    AppConfig.deviceModel.isNotEmpty ? AppConfig.deviceModel : platform,
  );
  final osVersion = AppConfig.deviceOsVersion.isNotEmpty
      ? AppConfig.deviceOsVersion
      : Platform.operatingSystemVersion;
  final name = AppConfig.deviceDisplayName.isNotEmpty
      ? AppConfig.deviceDisplayName
      : model;

  return 'BeaverMobile/$version ($platform; $arch) device_id/$deviceId model/$model os/$osVersion name/${_encodeUAToken(name)}';
}

String _resolveDeviceArch(List<String> supportedAbis) {
  if (supportedAbis.any((abi) => abi.contains('arm64'))) {
    return 'arm64';
  }
  if (supportedAbis.any((abi) => abi.contains('armeabi'))) {
    return 'arm';
  }
  if (supportedAbis.any((abi) => abi.contains('x86_64'))) {
    return 'x86_64';
  }
  if (supportedAbis.any((abi) => abi.contains('x86'))) {
    return 'x86';
  }
  return 'arm64';
}

Future<void> initDeviceProfile() async {
  final deviceInfo = AppConfig.deviceInfoPlugin;
  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    AppConfig.deviceArch = _resolveDeviceArch(info.supportedAbis);
    AppConfig.deviceModel = '${info.brand}-${info.model}';
    AppConfig.deviceOsVersion = info.version.release;
    AppConfig.deviceDisplayName = '${info.brand} ${info.model}';
    return;
  }
  if (Platform.isIOS) {
    final info = await deviceInfo.iosInfo;
    AppConfig.deviceArch = 'arm64';
    // model 存 Apple 机器标识（如 iPhone17,3），下游自行解析展示
    AppConfig.deviceModel = info.utsname.machine;
    AppConfig.deviceOsVersion = info.systemVersion;
    // name 用系统设备名（用户设置的「我的 iPhone」等），无则回退机器标识
    AppConfig.deviceDisplayName = info.name.trim().isNotEmpty
        ? info.name.trim()
        : info.utsname.machine;
  }
}
