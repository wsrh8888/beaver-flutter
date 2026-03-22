import 'package:beaver/core/cache/index.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/api/file.dart';

/// 媒体业务逻辑层 - 对标 PC Business 结构
class MediaBusiness {
  final _mediaManager = getIt<MediaManager>();

  /// 获取本地媒体文件路径，如果不存在则返回在线地址并触发异步下载
  Future<String> getMediaPath(String fileKey, CacheType type) async {
    return await _mediaManager.get(type, fileKey);
  }

  /// 预下载媒体文件
  Future<void> preDownload(String fileKey, CacheType type) async {
    await _mediaManager.add(type, fileKey);
  }
}
