import 'package:get_it/get_it.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/core/database/db.dart';

/// 数据库相关依赖配置
void configureDatabaseDependencies(GetIt getIt) {
  // 数据库
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerLazySingleton<AppDatabase>(() => DatabaseManager.instance);
  }
}
