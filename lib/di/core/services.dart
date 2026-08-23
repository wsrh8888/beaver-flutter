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
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/core/datasync/emoji/sync.dart';

/// 数据服务层依赖配置
void configureServiceDependencies(GetIt getIt) {
  getIt.registerLazySingleton<UserService>(() => const UserService());
  getIt.registerLazySingleton<UserSyncStatusService>(
    () => const UserSyncStatusService(),
  );

  getIt.registerLazySingleton<FriendService>(() => const FriendService());
  getIt.registerLazySingleton<FriendVerifyService>(
    () => const FriendVerifyService(),
  );

  getIt.registerLazySingleton<ChatConversationService>(
    () => const ChatConversationService(),
  );
  getIt.registerLazySingleton<ChatMessageService>(
    () => const ChatMessageService(),
  );
  getIt.registerLazySingleton<ChatUserConversationService>(
    () => const ChatUserConversationService(),
  );
  getIt.registerLazySingleton<ChatSyncStatusService>(
    () => const ChatSyncStatusService(),
  );
  getIt.registerLazySingleton<ChatMessageMediaService>(
    () => const ChatMessageMediaService(),
  );

  getIt.registerLazySingleton<GroupService>(() => const GroupService());
  getIt.registerLazySingleton<GroupMemberService>(
    () => const GroupMemberService(),
  );
  getIt.registerLazySingleton<GroupJoinRequestService>(
    () => const GroupJoinRequestService(),
  );
  getIt.registerLazySingleton<GroupSyncStatusService>(
    () => const GroupSyncStatusService(),
  );

  getIt.registerLazySingleton<CircleService>(() => const CircleService());

  getIt.registerLazySingleton<DatasyncService>(() => const DatasyncService());
  getIt.registerLazySingleton<MediaService>(() => const MediaService());

  getIt.registerLazySingleton<EmojiService>(() => const EmojiService());
  getIt.registerLazySingleton<EmojiCollectService>(
    () => const EmojiCollectService(),
  );
  getIt.registerLazySingleton<EmojiPackageService>(
    () => const EmojiPackageService(),
  );
  getIt.registerLazySingleton<EmojiPackageCollectService>(
    () => const EmojiPackageCollectService(),
  );
  getIt.registerLazySingleton<EmojiPackageEmojiService>(
    () => const EmojiPackageEmojiService(),
  );
  getIt.registerLazySingleton<EmojiSync>(() => EmojiSync());
  getIt.registerLazySingleton<NotificationInboxService>(
    () => const NotificationInboxService(),
  );
  getIt.registerLazySingleton<NotificationReadCursorService>(
    () => const NotificationReadCursorService(),
  );
  getIt.registerLazySingleton<NotificationEventService>(
    () => const NotificationEventService(),
  );
}
