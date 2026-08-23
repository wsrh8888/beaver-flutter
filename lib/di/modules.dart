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

import 'core/network.dart';
import 'core/database.dart';
import 'core/services.dart';
import 'core/cache.dart';
import 'store.dart';
import 'business/user.dart';
import 'business/friend.dart';
import 'business/group.dart';
import 'business/circle.dart';
import 'business/chat.dart';
import 'business/message.dart';
import 'business/notification.dart';
import 'business/emoji.dart';
import 'business/media.dart';
import 'business/call.dart';
import 'features/auth.dart';

/// 模块注册
void registerModules(GetIt getIt) {
  // 核心层配置
  configureNetworkDependencies(getIt);
  configureDatabaseDependencies(getIt);
  configureServiceDependencies(getIt);
  configureCacheDependencies(getIt);
  configureStoreDependencies(getIt);
  
  // 业务层配置
  configureAuthDependencies(getIt); // Add this
  configureUserBusinessDependencies(getIt);
  configureFriendBusinessDependencies(getIt);
  configureGroupBusinessDependencies(getIt);
  configureCircleBusinessDependencies(getIt);
  configureChatBusinessDependencies(getIt);
  configureMessageBusinessDependencies(getIt);
  configureNotificationBusinessDependencies(getIt);
  configureEmojiBusinessDependencies(getIt);
  configureMediaBusinessDependencies(getIt);
  configureCallBusinessDependencies(getIt);
}
