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

import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/business/friend/friend_verify.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('receiver-friend-verify');

/// Handles friend_verify, friends and users updates in friend verify channel.
class FriendVerifyReceiver {
  Future<void> handleTableUpdates(Map<String, dynamic> tableUpdatesBody) async {
    final tableUpdates =
        (tableUpdatesBody['tableUpdates'] ?? tableUpdatesBody['tables'])
            as List?;
    if (tableUpdates == null) {
      _logger.warn({'text': '收到好友验证表更新但 tableUpdates 为空'});
      return;
    }
    _logger.info({'text': '开始处理好友验证表更新', 'data': {'count': tableUpdates.length}});

    final verifyUpdates = tableUpdates
        .where((update) => update['table'] == 'friend_verify')
        .toList();
    for (final update in verifyUpdates) {
      final data = update['data'] as List?;
      if (data == null) continue;
      for (final dataItem in data) {
        try {
          await getIt<FriendVerifyBusiness>().handleTableUpdates(
            dataItem['userId'] as String?,
            dataItem['verifyId'] as String?,
            dataItem['version'] as int? ?? 0,
          );
        } catch (e) {
          _logger.warn({'text': '处理好友验证更新失败', 'data': {'error': e.toString()}});
        }
      }
    }

    final Map<String, int> latestVersionByFriendId = {};
    final friendUpdates = tableUpdates
        .where((update) => update['table'] == 'friends')
        .toList();
    for (final update in friendUpdates) {
      final data = update['data'] as List?;
      if (data == null) continue;
      for (final dataItem in data) {
        final friendId = dataItem['friendId'] as String?;
        final version = dataItem['version'] as int? ?? 0;
        if (friendId == null || friendId.trim().isEmpty) continue;

        final oldVersion = latestVersionByFriendId[friendId] ?? 0;
        if (version > oldVersion) {
          latestVersionByFriendId[friendId] = version;
        }
      }
    }
    for (final item in latestVersionByFriendId.entries) {
      try {
        await getIt<FriendBusiness>().handleTableUpdates(item.value, item.key);
      } catch (e) {
        _logger.warn({'text': '处理好友更新失败', 'data': {'friendId': item.key, 'version': item.value, 'error': e.toString()}});
      }
    }

    final userUpdates = tableUpdates
        .where((update) => update['table'] == 'users')
        .toList();
    for (final update in userUpdates) {
      final data = update['data'] as List?;
      if (data == null) continue;
      for (final dataItem in data) {
        try {
          await getIt<UserBusiness>().handleTableUpdates(
            dataItem['userId'] as String? ?? '',
            dataItem['version'] as int? ?? 0,
          );
        } catch (e) {
          _logger.warn({'text': '处理用户更新失败', 'data': {'error': e.toString()}});
        }
      }
    }
  }
}

final friendVerifyReceiver = FriendVerifyReceiver();
