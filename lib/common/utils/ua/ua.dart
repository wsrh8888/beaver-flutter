import 'dart:io';
import 'package:beaver/common/config/config.dart';

/**
 * 生成移动端标准 User-Agent (深度对齐 desktop 版实现)
 */
String generateUserAgentIdentifier() {
  final String version = AppConfig.version;
  final String deviceId = AppConfig.deviceId;
  final String platform = Platform.isIOS ? 'ios' : 'android';

  // 额外包含系统版本信息
  final String osVersion = Platform.operatingSystemVersion;

  // 构建标准标识符
  // 格式：BeaverMobile/{version} {platform} device_id/{deviceId} (OS/{osVersion})
  return 'BeaverMobile/$version $platform device_id/$deviceId (OS/$osVersion)';
}
