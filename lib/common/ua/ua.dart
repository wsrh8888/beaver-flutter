import 'dart:io';
import 'package:beaver/common/config/config.dart';

/**
 * UA 模块第一层：构造层
 * 负责生成描述设备特征的标准化 User-Agent 字符串。
 */
String generateUserAgentIdentifier() {
  final String version = AppConfig.version;
  final String deviceId = AppConfig.deviceId;
  final String platform = Platform.isIOS ? 'ios' : 'android';
  final String osVersion = Platform.operatingSystemVersion;

  // 必须包含后端识别所需的魔法单词：beaver_mobile_android 或 beaver_mobile_ios
  final String magicWord = 'beaver_mobile_$platform';

  // 格式对标后端：BeaverMobile/1.0.0 android(beaver_mobile_android) device_id/XXXX (OS/XXXX)
  return 'BeaverMobile/$version $platform($magicWord) device_id/$deviceId (OS/$osVersion)';
}
