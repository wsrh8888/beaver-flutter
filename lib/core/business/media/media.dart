import 'package:beaver/core/cache/media_manager.dart';
import 'package:beaver/types/cache.dart';

/// 媒体业务逻辑 - 对标 Desktop MediaBusiness
/// 职责：为 UI 提供集中的媒体资源访问接口
class MediaBusiness {
  /// 获取媒体资源地址 (带缓存逻辑)
  Future<String> getMediaPath(String fileKey, CacheType type) async {
    return mediaManager.get(type, fileKey);
  }

  /// 预下载/添加到缓存
  Future<String?> addMediaPath(String fileKey, CacheType type) async {
    return mediaManager.add(type, fileKey);
  }
}
