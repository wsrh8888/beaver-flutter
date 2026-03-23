import 'package:get_it/get_it.dart';
import 'package:beaver/core/datasync/manager.dart';

import 'modules.dart';

final getIt = GetIt.instance;

/// 依赖注入初始化
Future<void> configureDependencies() async {
  // 注册所有模块
  registerModules(getIt);
  
  // 数据同步层
  getIt.registerLazySingleton<DataSyncManager>(() => syncManager);
}
