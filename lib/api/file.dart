import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/types/api/file.dart';
import 'package:beaver/shared/utils/file_util.dart';

final _logger = Logger('fileApi');

/// 预览文件
String previewOnlineFileApi(String fileKey) {
  // fileKey 为 MD5 + 后缀
  return '$baseUrl/api/file/preview/$fileKey';
}

/// 上传文件总入口 (对标 PC uploadFileApi)
Future<BaseResponse<IFileUploadResult>> uploadFileApi(String filePath) async {
  // 1. 上传到本地 (Dev 推荐使用)
  return await uploadLocalApi(filePath);

  // 2. 上传到七牛云 (Prod 可开启)
  // return await uploadQiniuApi(filePath);
}

/// 上传到本地 (对应 PC uploadToLocalApi)
Future<BaseResponse<IFileUploadResult>> uploadLocalApi(String filePath) async {
  return _uploadFileApiWithTarget(filePath, 'uploadLocal');
}

/// 上传到七牛 (对应 PC uploadQiniuApi)
Future<BaseResponse<IFileUploadResult>> uploadQiniuApi(String filePath) async {
  return _uploadFileApiWithTarget(filePath, 'uploadQiniu');
}

/// 内部通用上传逻辑
Future<BaseResponse<IFileUploadResult>> _uploadFileApiWithTarget(
  String filePath,
  String endpoint,
) async {
  final uploadUrl = '$baseUrl/api/file/$endpoint';

  _logger.info({
    'text': '开始上传文件',
    'endpoint': endpoint,
    'path': filePath,
    'url': uploadUrl,
  });

  try {
    // 自动获取文件详情
    final fileInfo = await FileUtil.getFileInfo(filePath);

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'fileInfo': jsonEncode(fileInfo.toJson()),
    });

    final response = await httpClient.post<IFileUploadResult>(
      uploadUrl,
      data: formData,
      fromJsonT: (json) => IFileUploadResult.fromJson(json),
    );

    if (response.isSuccess) {
      _logger.info({'text': '文件上传成功', 'fileKey': response.result?.fileKey});
    } else {
      _logger.error({
        'text': '文件上传服务返回错误',
        'code': response.code,
        'msg': response.msg,
      });
    }
    return response;
  } catch (e) {
    _logger.error({'text': '文件上传异常', 'error': e.toString()});
    return BaseResponse(code: 500, msg: '上传异常: $e');
  }
}
