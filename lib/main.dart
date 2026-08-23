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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:beaver/app/app.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/app/app.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/common/ua/http_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 初始化日志
  await Logger.init();

  // 2. 初始化本地存储
  await StorageUtil.init();

  // 3. 初始化设备信息
  await AppConfig.init();

  // 4. UA 适配层注入
  HttpOverrides.global = BeaverUaHttpAdapter();

  // 配置依赖注入
  await configureDependencies();

  // 只要有 userId 就初始化数据库；有 token 再连接 WS
  final token = StorageUtil.getString('token');
  final userId = StorageUtil.getString('userId');
  if (userId != null && userId.isNotEmpty) {
    await DatabaseManager.init(userId);
    if (token != null && token.isNotEmpty) {
      getIt<WsConnectionManager>().connectWithToken(token);
    }
    // 自动初始化全局 Store 数据 (对标 desktop.initApp)
    getIt<AppStore>().initApp();
  }

  runApp(const BeaverApp());
}

