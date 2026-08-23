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

enum CreateGroupStatus { initial, loading, success, error }

class CreateGroupState {
  final CreateGroupStatus status;
  final List<ContactModel> contacts;
  final List<ContactModel> selectedContacts;
  final String searchQuery;
  final String? groupId;
  final String? errorMessage;

  const CreateGroupState({
    this.status = CreateGroupStatus.initial,
    this.contacts = const [],
    this.selectedContacts = const [],
    this.searchQuery = '',
    this.groupId,
    this.errorMessage,
  });

  CreateGroupState copyWith({
    CreateGroupStatus? status,
    List<ContactModel>? contacts,
    List<ContactModel>? selectedContacts,
    String? searchQuery,
    String? groupId,
    String? errorMessage,
  }) {
    return CreateGroupState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      selectedContacts: selectedContacts ?? this.selectedContacts,
      searchQuery: searchQuery ?? this.searchQuery,
      groupId: groupId ?? this.groupId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

