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

import 'dart:async';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/core/datasync/index.dart';

// 模块级日志实例（对标 PC：在文件顶部定义 logger）
final _logger = Logger('dataSyncManager');

/// 数据同步管理器
///
/// 职责：协调全局数据同步
/// - 管理同步状态
/// - 按顺序执行各模块同步
/// - 处理同步错误
class DataSyncManager {
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;
  int _lastSyncTime = 0;

  final _statusController = StreamController<String>.broadcast();
  Stream<String> get statusStream => _statusController.stream;

  /// 获取当前同步状态
  String getStatus() {
    return _isSyncing ? 'syncing' : 'idle';
  }

  /// 自动开始全量同步流程
  /// [isBackground] 是否为后台同步，后台同步不会触发全量加载的 UI 状态
  Future<void> autoSync({bool isBackground = false}) async {
    if (_isSyncing) return;

    // 如果最近 60 秒内同步过，且是后台触发，则跳过
    final now = DateTime.now().millisecondsSinceEpoch;
    if (isBackground && (now - _lastSyncTime < 60000)) {
      return;
    }

    try {
      _logger.info({'text': '开始全量同步', 'data': {'isBackground': isBackground}});
      _isSyncing = true;
      
      // 只有非后台同步才发送 syncing 状态（触发 UI 遮罩或加载条）
      if (!isBackground) {
        _statusController.add('syncing');
      }

      // 1. 同步用户资料
      await userDatasync.checkAndSync();
      // 2. 聊天相关同步 (含消息、会话元数据、用户会话设置)
      await chatDatasync.checkAndSync();
      // 3. 好友关系同步 (含好友资料、好友验证)
      await friendDatasync.checkAndSync();
      // 4. 群组资料同步 (含群资料、群成员、入群申请)
      await groupDatasync.checkAndSync();
      // 5. 圈子资料同步
      await circleDatasync.checkAndSync();
      // 6. 表情同步
      await emojiSync.checkAndSync();
      // 7. 通知事件同步
      await notificationSync.checkAndSync();

      _isSyncing = false;
      _lastSyncTime = DateTime.now().millisecondsSinceEpoch;
      
      // 只有非后台同步才发送 ready 状态（触发 initApp 重新加载内存）
      if (!isBackground) {
        _statusController.add('ready');
      }
    } catch (e) {
      _isSyncing = false;
      if (!isBackground) {
        _statusController.add('error');
      }
    }
  }
}

final syncManager = DataSyncManager();
