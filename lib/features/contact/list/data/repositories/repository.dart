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

import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/contact.dart';

class ContactListRepository {
  final FriendRepositoryInterface _friendRepository;

  ContactListRepository({FriendRepositoryInterface? friendRepository}) 
    : _friendRepository = friendRepository ?? getIt<FriendRepositoryInterface>();

  Future<List<ContactModel>> getContactList() async {
    return _friendRepository.getContactList();
  }

  // 根据字母分组联系人
  Map<String, List<ContactModel>> groupContactsByLetter(List<ContactModel> contacts) {
    return _friendRepository.groupContactsByLetter(contacts);
  }

  // 获取索引列表
  List<String> getIndexList(Map<String, List<ContactModel>> groups) {
    return _friendRepository.getIndexList(groups);
  }
}