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

