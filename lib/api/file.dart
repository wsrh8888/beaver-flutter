import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/config/env.dart';
import 'package:beaver/types/api/file.dart';
import 'package:beaver/shared/utils/file_util.dart';

/// 预览文件
String previewOnlineFileApi(String fileKey) {
  // fileKey 为 MD5 + 后缀
  return '$baseUrl/api/file/preview/$fileKey';
}

/// 上传文件总入口 (对标 PC uploadFileApi)
Future<BaseResponse<IFileUploadResult>> uploadFileApi(
  String filePath, {
  String? fileKey,
  FileInfo? fileInfo,
}) async {
  // 下面演示两种环境的切换逻辑，开发者按需注释/取消注释即可
  
  // 1. 上传到本地
  // return await uploadLocalApi(filePath, fileKey: fileKey, fileInfo: fileInfo);
  
  // 2. 上传到七牛云
  return await uploadQiniuApi(filePath, fileKey: fileKey, fileInfo: fileInfo);
}

/// 上传到本地 (对应 PC uploadToLocalApi)
Future<BaseResponse<IFileUploadResult>> uploadLocalApi(
  String filePath, {
  String? fileKey,
  FileInfo? fileInfo,
}) async {
  return _uploadFileApiWithTarget(filePath, 'uploadLocal', fileKey: fileKey, fileInfo: fileInfo);
}

/// 上传到七牛 (对应 PC uploadQiniuApi)
Future<BaseResponse<IFileUploadResult>> uploadQiniuApi(
  String filePath, {
  String? fileKey,
  FileInfo? fileInfo,
}) async {
  return _uploadFileApiWithTarget(filePath, 'uploadQiniu', fileKey: fileKey, fileInfo: fileInfo);
}

/// 内部通用上传逻辑 (对标 PC uploadFileApiWithTarget)
Future<BaseResponse<IFileUploadResult>> _uploadFileApiWithTarget(
  String filePath,
  String endpoint, {
  String? fileKey,
  FileInfo? fileInfo,
}) async {
  String uploadUrl = '/api/file/$endpoint';
  if (fileKey != null) {
    uploadUrl += '?fileKey=${Uri.encodeComponent(fileKey)}';
  }

  // 对标 PC 逻辑：如果外部没传 fileInfo，我们在 API 层自动获取
  final finalInfo = fileInfo ?? await FileUtil.getFileInfo(filePath);

  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(filePath),
    'fileInfo': jsonEncode(finalInfo.toJson()), // 对标 PC: JSON.stringify(fileInfo)
  });

  return httpClient.post<IFileUploadResult>(
    uploadUrl,
    data: formData,
    fromJsonT: (json) => IFileUploadResult.fromJson(json),
  );
}
