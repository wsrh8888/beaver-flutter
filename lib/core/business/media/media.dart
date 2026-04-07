import 'package:beaver/api/file.dart';
import 'package:beaver/core/cache/media_manager.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/types/api/file.dart';

/// 媒体业务逻辑
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

  /// 上传文件并返回上传结果 (对标 PC uploadFileApi)
  Future<IFileUploadResult?> uploadFile(String filePath) async {
    final response = await uploadFileApi(filePath);
    if (response.isSuccess && response.result != null) {
      return response.result;
    }
    return null;
  }
}
