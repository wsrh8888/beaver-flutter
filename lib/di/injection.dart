import 'package:get_it/get_it.dart';
import 'package:beaver/common/config/index.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/core/datasync/sync.dart';
import 'package:beaver/features/auth/data/repositories/auth_repository.dart';
import 'package:beaver/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/core/database/services/index.dart';

final getIt = GetIt.instance;

/// 依赖注入初始化
Future<void> configureDependencies() async {
  // 1. 基础工具初始化
  await StorageUtil.init();

  // 2. 核心网络客户端 (使用 request.dart 中的全局 httpClient 实例)
  getIt.registerSingleton<HttpClient>(httpClient);

  getIt.registerLazySingleton<WsConnectionManager>(() => WsConnectionManager());

  // 3. 业务仓库实现
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // 4. 数据同步管理器
  getIt.registerLazySingleton<SyncManager>(
    () => SyncManager(),
  );

  // 5. 数据库
  getIt.registerFactory<AppDatabase>(() => DatabaseManager.instance);

  // 6. 数据访问层
  getIt.registerFactory<UserService>(() => UserService(getIt<AppDatabase>()));
  getIt.registerFactory<MessageService>(() => MessageService(getIt<AppDatabase>()));
  getIt.registerFactory<ConversationService>(() => ConversationService(getIt<AppDatabase>()));
  getIt.registerFactory<FriendService>(() => FriendService(getIt<AppDatabase>()));
  getIt.registerFactory<DatasyncService>(() => DatasyncService(getIt<AppDatabase>()));
  getIt.registerFactory<GroupService>(() => GroupService(getIt<AppDatabase>()));
  getIt.registerFactory<GroupMemberService>(() => GroupMemberService(getIt<AppDatabase>()));
  getIt.registerFactory<GroupJoinRequestService>(() => GroupJoinRequestService(getIt<AppDatabase>()));
  getIt.registerFactory<ChatSyncStatusService>(() => ChatSyncStatusService(getIt<AppDatabase>()));
  getIt.registerFactory<ChatService>(() => ChatService(getIt<AppDatabase>()));
  getIt.registerFactory<EmojiService>(() => EmojiService(getIt<AppDatabase>()));
  getIt.registerFactory<NotificationService>(() => NotificationService(getIt<AppDatabase>()));

  print('[DI] 依赖注入配置完成');
}
