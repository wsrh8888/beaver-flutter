import 'package:beaver/types/cache.dart';

/// 缓存类型映射配置
class CachePathConfig {
  static const String brandFolder = 'beaver';

  static String userCacheRoot(String userId) {
    return '$brandFolder/users/$userId/cache';
  }

  static String userDbRoot(String userId) {
    return '$brandFolder/users/$userId/db';
  }

  /// 按日期分目录，例如 2026/06/06
  static String getDateFolder([DateTime? date]) {
    final d = date ?? DateTime.now();
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}/$month/$day';
  }

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

  /// images/2026/06/06
  static String getRelativePath(CacheType type, String userId, [DateTime? date]) {
    return '${userCacheRoot(userId)}/${getSubFolder(type)}/${getDateFolder(date)}';
  }
}
