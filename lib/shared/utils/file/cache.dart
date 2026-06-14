import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

/// 从完整 URL 提取文件后缀
String getFileExtFromUrl(String fileUrl) {
  if (fileUrl.isEmpty) return '';

  try {
    if (fileUrl.startsWith('http://') || fileUrl.startsWith('https://')) {
      return p.extension(Uri.parse(fileUrl).path);
    }
  } catch (_) {}

  return '';
}

/// 根据文件内容 MD5 生成本地磁盘文件名
String getCacheLocalFileName(String md5, [String? fileUrl]) {
  if (md5.isEmpty) return '';
  final ext = fileUrl != null ? getFileExtFromUrl(fileUrl) : '';
  return '$md5$ext';
}

/// 计算文件内容 MD5
Future<String> calculateFileMD5(String filePath) async {
  final file = File(filePath);
  final bytes = await file.readAsBytes();
  return md5.convert(bytes).toString();
}

/// 将临时下载文件移动到内容寻址的最终路径（已存在则删临时文件）
Future<String> moveDownloadToCache(String tempPath, String finalPath) async {
  await Directory(p.dirname(finalPath)).create(recursive: true);

  final finalFile = File(finalPath);
  if (await finalFile.exists()) {
    final tempFile = File(tempPath);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
    return finalPath;
  }

  await File(tempPath).rename(finalPath);
  return finalPath;
}
