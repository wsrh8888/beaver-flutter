import 'package:get_it/get_it.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/core/datasync/sync.dart';
import 'package:beaver/features/auth/login/data/repositories/repository.dart';
import 'package:beaver/features/auth/register/data/repositories/repository.dart';
import 'package:beaver/shared/utils/storage_util.dart';
// import 'package:beaver/core/database/services/index.dart';

import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/core/business/notification/notification.dart';

import 'package:beaver/core/business/moment/moment.dart';

final getIt = GetIt.instance;

/// 依赖注入初始化
Future<void> configureDependencies() async {
  // 1. 基础工具初始化
  await StorageUtil.init();

  // 2. 核心网络客户端
  getIt.registerSingleton<HttpClient>(httpClient);
  getIt.registerLazySingleton<WsConnectionManager>(() => WsConnectionManager());

  // 3. 数据库
  getIt.registerLazySingleton<AppDatabase>(() => DatabaseManager.instance);

  // 4. 数据处理层 (Services - Direct DB Access)
  getIt.registerLazySingleton<UserService>(() => UserService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<FriendService>(() => FriendService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<DatasyncService>(() => DatasyncService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<GroupService>(() => GroupService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<MediaService>(() => MediaService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<NotificationInboxService>(() => NotificationInboxService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<NotificationReadCursorService>(() => NotificationReadCursorService(getIt<AppDatabase>()));
  // ... 其他 service

  // 5. 业务门面层 (Business Facades - UI calls these)
  getIt.registerLazySingleton<UserBusiness>(() => UserBusiness());
  getIt.registerLazySingleton<FriendBusiness>(() => FriendBusiness());
  getIt.registerLazySingleton<GroupBusiness>(() => GroupBusiness());
  getIt.registerLazySingleton<NotificationBusiness>(() => NotificationBusiness());
  getIt.registerLazySingleton<ConversationBusiness>(() => ConversationBusiness());
  getIt.registerLazySingleton<MessageBusiness>(() => MessageBusiness());
  getIt.registerLazySingleton<MomentBusiness>(() => MomentBusiness());

  // 6. 数据同步层
  getIt.registerLazySingleton<SyncManager>(() => SyncManager());

  print('[DI] 依赖注入配置完成');
}
