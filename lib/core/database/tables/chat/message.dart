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

/// 聊天消息表 (与 PC tables/chat/message.ts 一致)
class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get messageId => text().named('message_id')();
  TextColumn get conversationId => text().named('conversation_id')();
  IntColumn get conversationType => integer().named('conversation_type')();
  IntColumn get seq => integer().named('seq').withDefault(const Constant(0))();
  TextColumn get sendUserId => text().named('send_user_id').nullable()();
  IntColumn get msgType => integer().named('msg_type')();
  TextColumn get targetMessageId => text().named('target_message_id').nullable()();
  TextColumn get msgPreview => text().named('msg_preview').nullable()();
  TextColumn get msg => text().named('msg').nullable()();
  IntColumn get sendStatus => integer().named('send_status').withDefault(const Constant(1))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (message_id)'];
}
