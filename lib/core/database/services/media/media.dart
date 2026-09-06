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

import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-media-media');

class MediaService extends BaseService {
  const MediaService();

  Future<void> upsert(Map<String, dynamic> req) async {
    try {

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await db.into(db.mediaTable).insert(
      MediaTableCompanion(
        url: Value(req['url'] as String),
        md5: req.containsKey('md5') ? Value(req['md5'] as String?) : const Value.absent(),
        path: Value(req['path'] as String),
        type: Value(req['type'] as String),
        size: req.containsKey('size') ? Value(req['size'] as int?) : const Value.absent(),
        createdAt: Value(req['createdAt'] ?? now),
        updatedAt: Value(req['updatedAt'] ?? now),
        isDeleted: Value(req['isDeleted'] ?? 0),
      ),
      mode: InsertMode.insertOrReplace,
    );
    } catch (e, st) {
      _logger.warn({'text':'MediaService.upsert 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getMediaByUrl(String url) async {
    try {

    final result = await (db.select(db.mediaTable)..where((t) => t.url.equals(url))).get();
    if (result.isEmpty) return null;
    return result.first.toJson();
    } catch (e, st) {
      _logger.warn({'text':'MediaService.getMediaByUrl 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<void> deleteByUrl(String url) async {
    try {

    await (db.delete(db.mediaTable)..where((t) => t.url.equals(url))).go();
    } catch (e, st) {
      _logger.warn({'text':'MediaService.deleteByUrl 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
