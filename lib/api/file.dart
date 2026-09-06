/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/types/api/file.dart';
import 'package:beaver/shared/utils/file/info.dart';

final _logger = Logger('fileApi');

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
  final uploadUrl = '$baseUrl/api/file/v1/$endpoint';

  _logger.info({
    'text': '开始上传文件',
    'data': {'endpoint': endpoint, 'path': filePath, 'url': uploadUrl},
  });

  try {
    // 自动获取文件详情
    final fileInfo = await getFileInfo(filePath);

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
      final fileUrl = response.result?.fileUrl;
      _logger.info({'text': '文件上传成功', 'data': {'fileUrl': fileUrl}});
    } else {
      _logger.error({
        'text': '文件上传服务返回错误',
        'data': {'code': response.code, 'msg': response.msg},
      });
    }
    return response;
  } catch (e) {
    _logger.error({'text': '文件上传异常', 'data': {'error': e.toString()}});
    return BaseResponse(code: 500, msg: '上传异常: $e');
  }
}
