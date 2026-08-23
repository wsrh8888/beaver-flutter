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

import 'package:get_it/get_it.dart';
import 'package:beaver/store/app/app.dart';
import 'package:beaver/store/user/user.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/store/group/group.dart';
import 'package:beaver/store/circle/circle.dart';
import 'package:beaver/store/notification/notification.dart';
import 'package:beaver/store/message/message.dart';
import 'package:beaver/store/emoji/emoji.dart';
import 'package:beaver/store/update/update.dart';
import 'package:beaver/store/ws/ws.dart';
import 'package:beaver/store/call/call.dart';
import 'package:beaver/store/call/call_list.dart';
import 'package:beaver/store/message_media/message_media.dart';
import 'package:beaver/store/voice/voice.dart';
import 'package:beaver/store/group/group_member.dart';
import 'package:beaver/store/group/group_join_request.dart';
import 'package:beaver/store/friend/friend_verify.dart';

/// 全局 Store 依赖配置
void configureStoreDependencies(GetIt getIt) {
  // App 状态与生命周期
  getIt.registerLazySingleton<AppStore>(() => AppStore());

  // 各业务分模块 Store (单例)
  getIt.registerLazySingleton<UserStore>(() => UserStore());
  getIt.registerLazySingleton<ContactStore>(() => ContactStore());
  getIt.registerLazySingleton<ChatStore>(() => ChatStore());
  getIt.registerLazySingleton<FriendStore>(() => FriendStore());
  getIt.registerLazySingleton<FriendVerifyStore>(() => FriendVerifyStore());
  getIt.registerLazySingleton<GroupStore>(() => GroupStore());
  getIt.registerLazySingleton<CircleStore>(() => CircleStore());
  getIt.registerLazySingleton<NotificationStore>(() => NotificationStore());
  getIt.registerLazySingleton<MessageStore>(() => MessageStore());
  getIt.registerLazySingleton<EmojiStore>(() => EmojiStore());
  getIt.registerLazySingleton<UpdateStore>(() => UpdateStore(getIt<UserStore>()));
  getIt.registerLazySingleton<WsStore>(() => WsStore());
  getIt.registerLazySingleton<CallStore>(() => CallStore());
  getIt.registerLazySingleton<CallListStore>(() => CallListStore());
  getIt.registerLazySingleton<VoicePlayerStore>(() => VoicePlayerStore());
  getIt.registerLazySingleton<MessageMediaStore>(() => MessageMediaStore());
  getIt.registerLazySingleton<GroupMemberStore>(() => GroupMemberStore());
  getIt.registerLazySingleton<GroupJoinRequestStore>(
    () => GroupJoinRequestStore(),
  );
}
