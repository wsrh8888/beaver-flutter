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

import 'package:beaver/api/file.dart';
import 'package:beaver/core/cache/media_manager.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/types/api/file.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('media-business');

/// 媒体业务逻辑
/// 职责：为 UI 提供集中的媒体资源访问接口
class MediaBusiness {
  /// 获取媒体资源地址 (带缓存逻辑)
  Future<String> getMediaPath(String fileUrl, CacheType type) async {
    return mediaManager.get(type, fileUrl);
  }

  /// 预下载/添加到缓存
  Future<String?> addMediaPath(String fileUrl, CacheType type) async {
    return mediaManager.add(type, fileUrl);
  }

  /// 上传文件并返回上传结果 (对标 PC uploadFileApi)
  Future<IFileUploadResult?> uploadFile(String filePath) async {
    _logger.info({'text': '开始上传文件', 'data': {'filePath': filePath}});
    try {
      final response = await uploadFileApi(filePath);
      if (response.isSuccess && response.result != null) {
        _logger.info({
          'text': '上传文件成功',
          'data': {'filePath': filePath, 'url': response.result?.url},
        });
        return response.result;
      }
      _logger.error({
        'text': '上传文件接口失败',
        'data': {'filePath': filePath, 'code': response.code, 'msg': response.msg},
      });
      return null;
    } catch (e) {
      _logger.error({
        'text': '上传文件异常',
        'data': {'filePath': filePath, 'error': e.toString()},
      });
      rethrow;
    }
  }
}
