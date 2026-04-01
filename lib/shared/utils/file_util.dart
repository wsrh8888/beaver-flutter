import 'dart:io';
import 'package:flutter/material.dart';
import 'package:beaver/types/api/file.dart';
import 'package:video_player/video_player.dart';

class FileUtil {
  /// 获取文件的完整信息 (对标 PC getFileInfo)
  static Future<FileInfo> getFileInfo(String filePath) async {
    final file = File(filePath);
    final mimeType = _getFileType(filePath);

    switch (mimeType) {
      case 'image':
        final imageSize = await getImageAttribute(file);
        return FileInfo(type: mimeType, imageFile: imageSize);
      case 'video':
        final videoInfo = await getVideoInfo(file);
        return FileInfo(type: mimeType, videoFile: videoInfo);
      default:
        return FileInfo(type: mimeType);
    }
  }

  /// 获取图片宽高 (对标 PC getImageAttribute)
  static Future<ImageSize> getImageAttribute(File file) async {
    try {
      final data = await file.readAsBytes();
      final image = await decodeImageFromList(data);
      return ImageSize(width: image.width, height: image.height);
    } catch (e) {
      return ImageSize(width: 0, height: 0);
    }
  }

  /// 获取视频信息 (对标 PC getVideoInfo)
  static Future<VideoInfo> getVideoInfo(File file) async {
    try {
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      final info = VideoInfo(
        width: controller.value.size.width.toInt(),
        height: controller.value.size.height.toInt(),
        duration: controller.value.duration.inSeconds,
      );
      await controller.dispose();
      return info;
    } catch (e) {
      return VideoInfo(width: 0, height: 0, duration: 0);
    }
  }

  /// 简单的类型判断 (对标 PC getFileType)
  static String _getFileType(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext)) return 'image';
    if (['mp4', 'mov', 'avi', 'mkv', 'flv'].contains(ext)) return 'video';
    if (['mp3', 'wav', 'aac', 'm4a'].contains(ext)) return 'audio';
    return 'other';
  }
}
