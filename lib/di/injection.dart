import 'package:get_it/get_it.dart';
import 'package:beaver/core/network/api/api_client.dart';
import 'package:beaver/core/sync/sync_manager.dart';
import 'package:beaver/features/auth/data/repositories/auth_repository.dart';
import 'package:beaver/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:beaver/shared/utils/storage_util.dart';

final getIt = GetIt.instance;

/// 依赖注入初始化
Future<void> configureDependencies() async {
  // 1. 基础工具初始化
  await StorageUtil.init();

  // 2. 核心网络客户端 (对标 desktop 的全局 axios 实例)
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: 'https://api.beaver.com'), // 建议从 config 读取
  );

  // 3. 业务仓库实现
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: getIt<ApiClient>()),
  );

  // 4. 数据同步管理器
  getIt.registerLazySingleton<SyncManager>(
    () => SyncManager.instance,
  );

  print('[DI] 依赖注入配置完成');
}
