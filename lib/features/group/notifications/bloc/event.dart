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

abstract class GroupNotificationsEvent extends Equatable {
  const GroupNotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroupNotificationsEvent extends GroupNotificationsEvent {
  const LoadGroupNotificationsEvent();
}

class SwitchTabEvent extends GroupNotificationsEvent {
  final String tab;
  const SwitchTabEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class AcceptGroupRequestEvent extends GroupNotificationsEvent {
  final int id;
  const AcceptGroupRequestEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RejectGroupRequestEvent extends GroupNotificationsEvent {
  final int id;
  const RejectGroupRequestEvent(this.id);

  @override
  List<Object?> get props => [id];
}
