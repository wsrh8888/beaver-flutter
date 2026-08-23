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
