import 'package:beaver/types/cache.dart';

/// 缓存类型映射配置
/// 对标移动端大厂 (微信/钉钉) 存储规范
class CachePathConfig {
  /// 品牌主目录 (方便统一清理和定位)
  static const String brandFolder = 'beaver';

  /// 用户级缓存根路径 (相对于 App Documents)
  /// ⚠️ 重要：不可在开头加 /，否则 path.join 会尝试写系统根目录导致权限错误
  static String userCacheRoot(String userId) {
    return '$brandFolder/users/$userId/cache';
  }

  /// 数据库路径根目录 (相对于 App Documents)
  static String userDbRoot(String userId) {
    return '$brandFolder/users/$userId/db';
  }

  /// 获取类型对应的子目录
  static String getSubFolder(CacheType type) {
    switch (type) {
      case CacheType.image:
        return 'images';
      case CacheType.video:
        return 'videos';
      case CacheType.voice:
        return 'voices';
      case CacheType.avatar:
        return 'avatars';
      case CacheType.file:
        return 'files';
    }
  }

  /// 获取完整的相对路径 (用于存库或定位)
  static String getRelativePath(CacheType type, String userId) {
    return '${userCacheRoot(userId)}/${getSubFolder(type)}';
  }
}
