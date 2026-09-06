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
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-chat-sync_status');

class ChatSyncStatusService extends BaseService {
  const ChatSyncStatusService();

  /// 获取多个会话的版本/seq信息
  Future<List<ChatSyncStatusData>> getModuleVersions(String module, List<String> conversationIds) async {
    try {

    return (db.select(db.chatSyncStatus)
      ..where((t) => t.module.equals(module))
      ..where((t) => t.conversationId.isIn(conversationIds))).get();
    } catch (e, st) {
      _logger.warn({'text':'ChatSyncStatusService.getModuleVersions 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取单个会话的同步状态
  Future<ChatSyncStatusData?> getSyncStatus(String module, String conversationId) async {
    try {

    return (db.select(db.chatSyncStatus)
      ..where((t) => t.module.equals(module))
      ..where((t) => t.conversationId.equals(conversationId))).getSingleOrNull();
    } catch (e, st) {
      _logger.warn({'text':'ChatSyncStatusService.getSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 更新同步状态
  Future<void> upsertSyncStatus({
    required String module,
    required String conversationId,
    int? seq,
    int? version,
  }) async {
    try {

    await db.into(db.chatSyncStatus).insertOnConflictUpdate(
      ChatSyncStatusCompanion(
        conversationId: Value(conversationId),
        module: Value(module),
        seq: seq != null ? Value(seq) : const Value.absent(),
        version: version != null ? Value(version) : const Value.absent(),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
      ),
    );
    } catch (e, st) {
      _logger.warn({'text':'ChatSyncStatusService.upsertSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
