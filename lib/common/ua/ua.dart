import 'dart:io';
import 'package:beaver/common/config/config.dart';

/**
 * UA 模块第一层：构造层
 * 负责生成描述设备特征的标准化 User-Agent 字符串。
 * 对标大厂格式：BeaverMobile/1.0.0 (android; arm64) device_id/xxx
 */
String generateUserAgentIdentifier() {
  final String version = AppConfig.version;
  final String deviceId = AppConfig.deviceId;
  final String platform = Platform.isIOS ? 'ios' : 'android';
  
  // 架构名称（标准化）
  // 注意：Flutter 中获取架构需要原生插件，这里简化处理
  // 实际项目中可以通过 MethodChannel 获取真实架构
  final String arch = 'arm64'; // 默认 arm64，大部分现代手机都是

  // 格式：BeaverMobile/1.0.0 (android; arm64) device_id/xyz789
  return 'BeaverMobile/$version ($platform; $arch) device_id/$deviceId';
}
