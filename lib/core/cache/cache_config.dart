/// 缓存类型枚举
enum CacheType {
  image,      // 聊天图片
  video,      // 视频
  voice,      // 语音
  avatar,     // 头像
  file,       // 普通文件
}

/// 缓存配置
class CacheConfig {
  /// 最大缓存大小（默认 500MB）
  static const int maxCacheSize = 500 * 1024 * 1024;
  
  /// 缓存过期时间（默认 7 天）
  static const Duration cacheExpireTime = Duration(days: 7);
  
  /// 图片压缩质量
  static const int imageQuality = 85;
  
  /// 图片最大宽度
  static const int imageMaxWidth = 1920;
  
  /// 图片最大高度
  static const int imageMaxHeight = 1920;
}

/// 文件类型映射
const Map<String, CacheType> fileTypeMapping = {
  // 图片
  '.jpg': CacheType.image,
  '.jpeg': CacheType.image,
  '.png': CacheType.image,
  '.gif': CacheType.image,
  '.bmp': CacheType.image,
  '.webp': CacheType.image,
  
  // 视频
  '.mp4': CacheType.video,
  '.avi': CacheType.video,
  '.mov': CacheType.video,
  '.wmv': CacheType.video,
  '.flv': CacheType.video,
  '.mkv': CacheType.video,
  
  // 音频
  '.mp3': CacheType.voice,
  '.wav': CacheType.voice,
  '.aac': CacheType.voice,
  '.ogg': CacheType.voice,
  '.m4a': CacheType.voice,
};
