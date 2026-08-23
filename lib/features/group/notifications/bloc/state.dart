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

import 'package:equatable/equatable.dart';
import 'package:beaver/types/business/group.dart';

enum GroupNotificationsStatus { initial, loading, success, error }

class GroupNotificationsState extends Equatable {
  final GroupNotificationsStatus status;
  final List<GroupNotification> notifications;
  final String? errorMessage;
  final String activeTab; // 'received' or 'sent'

  const GroupNotificationsState({
    this.status = GroupNotificationsStatus.initial,
    this.notifications = const [],
    this.errorMessage,
    this.activeTab = 'received',
  });

  GroupNotificationsState copyWith({
    GroupNotificationsStatus? status,
    List<GroupNotification>? notifications,
    String? errorMessage,
    String? activeTab,
  }) {
    return GroupNotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      activeTab: activeTab ?? this.activeTab,
    );
  }

  @override
  List<Object?> get props => [status, notifications, errorMessage, activeTab];
}
