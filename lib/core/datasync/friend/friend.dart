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

import 'package:beaver/core/datasync/friend/friend_sync.dart';
import 'package:beaver/core/datasync/friend/friend_verify_sync.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('datasync-friend-entry');

/// 好友数据同步统一入口
class FriendDatasync {
  Future<void> checkAndSync() async {
    _logger.info({'text': '开始同步好友数据（好友+验证）'});
    // 并行同步好友数据和好友验证数据
    await Future.wait([
      friendSyncModule.checkAndSync(),
      friendVerifySyncModule.checkAndSync(),
    ]).then((_) {
      _logger.info({'text': '好友数据同步完成'});
    }).catchError((e) {
      _logger.warn({'text': '好友数据同步部分失败', 'data': {'error': e.toString()}});
    });
  }
}

final friendDatasync = FriendDatasync();