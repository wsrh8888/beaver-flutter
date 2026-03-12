/// 应用级配置 (对标 desktop main/config：版本等；设备 ID 仍在请求层用 StorageUtil)
class AppConfig {
  static String _version = '1.0.0';

  /// 应用版本 (请求头 version；可从 package_info_plus 读取后 set)
  static String get version => _version;
  static set version(String v) => _version = v;
}
