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

import 'package:drift/drift.dart';

class NotificationEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventId => text().named('event_id')();
  TextColumn get eventType => text().named('event_type')();
  TextColumn get category => text().named('category')();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  TextColumn get fromUserId => text().named('from_user_id').nullable()();
  TextColumn get targetId => text().named('target_id').nullable()();
  TextColumn get targetType => text().named('target_type')();
  TextColumn get payload => text().named('payload').nullable()();
  IntColumn get priority => integer().named('priority').withDefault(const Constant(5))();
  IntColumn get status => integer().named('status').withDefault(const Constant(1))();
  TextColumn get dedupHash => text().named('dedup_hash').nullable()();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (event_id)'];
}
