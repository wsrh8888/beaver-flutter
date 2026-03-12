import 'package:flutter/material.dart';
import 'package:beaver/app/app.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/core/network/websocket/websocket.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/utils/storage_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  // 已登录：初始化 DB 并连接 WS（连接成功后自动 dataSyncManager.autoSync）
  final token = StorageUtil.getString('token');
  final userId = StorageUtil.getString('userId');
  if (token != null && token.isNotEmpty && userId != null && userId.isNotEmpty) {
    await DatabaseManager.init(userId);
    getIt<WsConnectionManager>().connectWithToken(token);
  }

  runApp(const BeaverApp());
}
