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

import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/core/business/group/group_join_request.dart';
import 'package:beaver/core/business/group/group_member.dart';
import 'package:beaver/types/business/group.dart';
import 'package:get_it/get_it.dart';

/// 群组业务层依赖配置
void configureGroupBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<GroupBusiness>(() => GroupBusiness());
  getIt.registerLazySingleton<GroupJoinRequestBusiness>(
    () => GroupJoinRequestBusiness(),
  );
  getIt.registerLazySingleton<GroupMemberBusiness>(() => GroupMemberBusiness());

  // 业务接口注册
  getIt.registerLazySingleton<GroupRepositoryInterface>(
    () => getIt<GroupBusiness>(),
  );
}
