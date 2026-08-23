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

import 'package:beaver/features/user/config/data/models/config.dart';

class UserConfigRepository {
  Future<FriendInfo> getFriendInfo(String conversationId) async {
    // 模拟获取好友信息
    await Future.delayed(const Duration(seconds: 1));
    return FriendInfo(
      userId: '123456',
      nickname: '张三',
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
      isOnline: true,
    );
  }

  Future<bool> toggleTopChat(String conversationId, bool isPinned) async {
    // 模拟置顶聊天
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> deleteFriend(String friendId) async {
    // 模拟删除好友
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

