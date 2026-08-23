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
import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/core/message/index.dart';

/// 网络相关依赖配置
void configureNetworkDependencies(GetIt getIt) {
  // 核心管理
  getIt.registerLazySingleton<MessageManager>(() => MessageManager());
  
  // 核心网络客户端
  if (!getIt.isRegistered<HttpClient>()) {
    getIt.registerSingleton<HttpClient>(httpClient);
  }
  if (!getIt.isRegistered<WsConnectionManager>()) {
    getIt.registerLazySingleton<WsConnectionManager>(() => WsConnectionManager());
  }
}
