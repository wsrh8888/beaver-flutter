import 'package:get_it/get_it.dart';
import 'package:beaver/core/cache/media_manager.dart';

/// 缓存层依赖配置
void configureCacheDependencies(GetIt getIt) {
  // 注册媒体管理器
  getIt.registerLazySingleton<MediaManager>(() => MediaManager());
}
