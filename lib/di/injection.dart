import 'package:get_it/get_it.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/common/request/api_client.dart';
import 'package:beaver/api/index.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/core/datasync/sync_manager.dart';
import 'package:beaver/features/auth/data/repositories/auth_repository.dart';
import 'package:beaver/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:beaver/shared/utils/storage_util.dart';

final getIt = GetIt.instance;

/// 依赖注入初始化
Future<void> configureDependencies() async {
  // 1. 基础工具初始化
  await StorageUtil.init();

  // 2. 核心网络客户端 (baseUrl 来自 env_config，对标 desktop common/config)
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: baseUrl),
  );
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt<ApiClient>()));
  getIt.registerLazySingleton<UserApi>(() => UserApi(getIt<ApiClient>()));
  getIt.registerLazySingleton<ChatApi>(() => ChatApi(getIt<ApiClient>()));

  getIt.registerLazySingleton<WsConnectionManager>(() => WsConnectionManager());

  // 3. 业务仓库实现
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: getIt<ApiClient>()),
  );

  // 4. 数据同步管理器
  getIt.registerLazySingleton<SyncManager>(
    () => SyncManager(),
  );

  // 5. 数据库：登录后 DatabaseManager.init(userId)，通过 GetIt 取当前实例
  getIt.registerFactory<AppDatabase>(() => DatabaseManager.instance);

  // 6. 数据访问层（依赖 AppDatabase，需在登录后使用）
  getIt.registerFactory<UserService>(() => UserService(getIt<AppDatabase>()));
  getIt.registerFactory<MessageService>(() => MessageService(getIt<AppDatabase>()));
  getIt.registerFactory<ConversationService>(() => ConversationService(getIt<AppDatabase>()));

  print('[DI] 依赖注入配置完成');
}
