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

import 'package:beaver/features/group/config/data/models/config.dart';

class GroupConfigRepository {
  Future<GroupInfo> getGroupInfo(String groupId) async {
    // 模拟获取群组信息
    await Future.delayed(const Duration(seconds: 1));
    return GroupInfo(
      groupId: groupId,
      title: '测试群聊',
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=group%20avatar&size=512x512',
      memberCount: 5,
    );
  }

  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    // 模拟获取群组成员
    await Future.delayed(const Duration(seconds: 1));
    return [
      GroupMember(
        userId: '1',
        nickname: '张三',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%201&size=512x512',
        role: 2,
      ),
      GroupMember(
        userId: '2',
        nickname: '李四',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%202&size=512x512',
        role: 0,
      ),
      GroupMember(
        userId: '3',
        nickname: '王五',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%203&size=512x512',
        role: 1,
      ),
    ];
  }

  Future<bool> updateGroupName(String groupId, String name) async {
    // 模拟更新群名?
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> quitGroup(String groupId) async {
    // 模拟退出群?
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

