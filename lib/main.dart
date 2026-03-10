import 'package:flutter/material.dart';
import 'package:beaver/app/app.dart';
import 'package:beaver/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化依赖注入 (网络, 数据库, 存储等)
  await configureDependencies();

  runApp(const BeaverApp());
}
