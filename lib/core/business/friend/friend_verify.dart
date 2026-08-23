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
import 'package:beaver/api/friend.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/friend.dart';

/// 好友验证业务逻辑 (对标 PC business/friend/friend-verify.ts)
class FriendVerifyBusiness {
  final Map<String, int> _lastHandledVersionByVerifyId = {};
  final _verifyUpdateController = StreamController<String>.broadcast();

  Stream<String> get verifyUpdateStream => _verifyUpdateController.stream;

  void notifyVerifyUpdate(String verifyId) {
    _verifyUpdateController.add(verifyId);
  }

  /**
   * @description 处理好友验证表更新
   */
  Future<void> handleTableUpdates(
    String? userId,
    String? verifyId,
    int version,
  ) async {
    if (verifyId == null || verifyId.trim().isEmpty) {
      return;
    }

    // 1. 版本控制：如果已处理过更高或相等版本，则跳过
    final lastVersion = _lastHandledVersionByVerifyId[verifyId] ?? 0;
    if (version <= lastVersion) {
      return;
    }

    print(
      '[FriendVerifyBusiness] 正在同步好友验证增量: verifyId=$verifyId, version=$version',
    );

    // 2. 调用 API 拉取最新验证信息
    final response = await getFriendVerifiesListByIdsApi(
      IGetFriendVerifiesListByIdsReq(verifyIds: [verifyId]),
    );

    if (response.code != 0 || response.result == null) {
      print('[FriendVerifyBusiness] 拉取验证信息失败: ${response.msg}');
      return;
    }

    // 3. 批量更新本地数据库
    if (response.result!.friendVerifies.isNotEmpty) {
      final verifyService = getIt<FriendService>();
      final companions = response.result!.friendVerifies
          .map((item) => item.toCompanion())
          .toList();
      await verifyService.batchCreateVerifies(companions);
    }

    // 4. 更新版本缓存
    _lastHandledVersionByVerifyId[verifyId] = version;
    notifyVerifyUpdate(verifyId);
    print('[FriendVerifyBusiness] 好友验证表同步完成');
  }
}
