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
import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show FlutterError, FlutterErrorDetails;
import 'package:beaver/app/app.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/app/app.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/common/ua/http_adapter.dart';

// 模块级日志实例（对标 PC：在文件顶部定义 logger）
final _logger = Logger('app');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 初始化日志
  await Logger.init();
  _logger.info({'text': '应用启动：日志模块已就绪'});

  // 2. 全局异常兜底（对标 PC main.ts 的 uncaughtException / unhandledRejection）
  // 2.1 Flutter 框架层异常（build / layout / 手势等）
  FlutterError.onError = (FlutterErrorDetails details) {
    _logger.error({
      'text': '界面构建异常',
      'data': {
        'error': details.exceptionAsString(),
        'stack': details.stack.toString(),
      },
    });
  };

  // 2.2 非 Flutter 平台层异常（原生回调、 isolates 等）
  PlatformDispatcher.instance.onError = (error, stack) {
    _logger.error({
      'text': '平台层未捕获异常',
      'data': {
        'error': error.toString(),
        'stack': stack.toString(),
      },
    });
    return true;
  };

  // 3. 初始化本地存储
  _logger.info({'text': '启动步骤：初始化本地存储'});
  await StorageUtil.init();

  // 4. 初始化设备信息
  _logger.info({'text': '启动步骤：初始化设备信息'});
  await AppConfig.init();

  // 5. UA 适配层注入
  HttpOverrides.global = BeaverUaHttpAdapter();

  // 配置依赖注入
  _logger.info({'text': '启动步骤：配置依赖注入'});
  await configureDependencies();

  // 只要有 userId 就初始化数据库；有 token 再连接 WS
  final token = StorageUtil.getString('token');
  final userId = StorageUtil.getString('userId');
  _logger.info({
    'text': '启动步骤：读取登录态',
    'data': {
      'hasUserId': userId != null && userId.isNotEmpty,
      'hasToken': token != null && token.isNotEmpty,
    },
  });
  if (userId != null && userId.isNotEmpty) {
    // 注入用户身份，使云端日志可关联用户
    Logger.setUserId(userId);
    _logger.info({'text': '启动步骤：初始化本地数据库'});
    await DatabaseManager.init(userId);
    if (token != null && token.isNotEmpty) {
      _logger.info({'text': '启动步骤：连接WebSocket'});
      getIt<WsConnectionManager>().connectWithToken(token);
    }
    // 自动初始化全局 Store 数据 (对标 desktop.initApp)
    _logger.info({'text': '启动步骤：初始化业务Store'});
    getIt<AppStore>().initApp();
  }

  // 6. 异步任务未捕获异常兜底（异步回调中抛出的异常走此通道）
  runZonedGuarded<void>(() {
    _logger.info({'text': '启动步骤：进入应用主界面'});
    runApp(const BeaverApp());
  }, (error, stack) {
    _logger.error({
      'text': '异步任务未捕获异常',
      'data': {
        'error': error.toString(),
        'stack': stack.toString(),
      },
    });
  });
}

