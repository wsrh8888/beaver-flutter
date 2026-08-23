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

import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/di/injection.dart';

/// 用户资料接收器 - 处理 users 表的操作 (对标 PC receivers/user/user.ts)
class UserReceiver {
  UserBusiness get _userBusiness => getIt<UserBusiness>();

  /**
   * 处理用户表更新通知
   */
  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final table = body['table'] as String?;
    final version = body['version'] as int?;
    final targetId = body['targetId'] as String?;

    if (table != 'users') {
      print('[UserReceiver] 收到非 users 表的更新: $table');
      return;
    }

    if (targetId != null && version != null) {
      await _userBusiness.handleTableUpdates(targetId, version);
    }
  }
}

final userReceiver = UserReceiver();