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

import 'package:beaver/types/business/contact.dart';

enum ContactListStatus { initial, loading, success, error }

class ContactListState {
  final ContactListStatus status;
  final List<ContactModel> contacts;
  final Map<String, List<ContactModel>> groupedContacts;
  final List<String> indexList;
  final String? errorMessage;
  final String currentIndex;
  final int friendRequestCount;
  final int groupNotificationCount;

  const ContactListState({
    this.status = ContactListStatus.initial,
    this.contacts = const [],
    this.groupedContacts = const {},
    this.indexList = const [],
    this.errorMessage,
    this.currentIndex = '',
    this.friendRequestCount = 0,
    this.groupNotificationCount = 0,
  });

  ContactListState copyWith({
    ContactListStatus? status,
    List<ContactModel>? contacts,
    Map<String, List<ContactModel>>? groupedContacts, 
    List<String>? indexList,
    String? errorMessage,
    String? currentIndex,
    int? friendRequestCount,
    int? groupNotificationCount,
  }) {
    return ContactListState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      groupedContacts: groupedContacts ?? this.groupedContacts,
      indexList: indexList ?? this.indexList,
      errorMessage: errorMessage ?? this.errorMessage,
      currentIndex: currentIndex ?? this.currentIndex,
      friendRequestCount: friendRequestCount ?? this.friendRequestCount,
      groupNotificationCount: groupNotificationCount ?? this.groupNotificationCount,
    );
  }
}
