/// 缓存类型枚举
/// 放置在 lib/types 下以供 UI 和业务层共享，实现与核心缓存实现的隔离。
enum CacheType {
  image, // 聊天图片/朋友圈图片
  video, // 视频
  voice, // 语音
  avatar, // 头像
  file, // 普通文件
}

/// 文件扩展名映射
const Map<String, CacheType> fileTypeMapping = {
  '.jpg': CacheType.image,
  '.jpeg': CacheType.image,
  '.png': CacheType.image,
  '.gif': CacheType.image,
  '.bmp': CacheType.image,
  '.webp': CacheType.image,
  '.mp4': CacheType.video,
  '.avi': CacheType.video,
  '.mov': CacheType.video,
  '.wmv': CacheType.video,
  '.flv': CacheType.video,
  '.mkv': CacheType.video,
  '.mp3': CacheType.voice,
  '.wav': CacheType.voice,
  '.aac': CacheType.voice,
  '.ogg': CacheType.voice,
  '.m4a': CacheType.voice,
};
