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

import 'package:beaver/core/datasync/index.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('datasync-group-entry');

/// 群组数据同步统一入口
class GroupDatasync {
  Future<void> checkAndSync() async {
    _logger.info({'text': '开始同步群组数据（资料+成员+申请）'});
    try {
      await groupSync.checkAndSync(); // 1. 同步群资料
      await groupMemberSync.checkAndSync(); // 2. 同步群成员
      await groupJoinRequestSync.checkAndSync(); // 3. 同步入群申请
      _logger.info({'text': '群组数据同步完成'});
    } catch (e) {
      _logger.warn({'text': '群组数据同步异常', 'data': {'error': e.toString()}});
    }
  }
}

final groupDatasync = GroupDatasync();
