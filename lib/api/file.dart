import 'package:beaver/common/config/env.dart';

/// 预览文件
String previewOnlineFileApi(String fileName) {
  // fileName 为 MD5 + 后缀
  return '$baseUrl/api/file/preview/$fileName';
}
