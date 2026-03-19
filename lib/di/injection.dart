import 'package:get_it/get_it.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/core/datasync/sync.dart';
import 'package:beaver/shared/utils/storage_util.dart';

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
  // 1. 核心网络客户端
  if (!getIt.isRegistered<HttpClient>()) {
    getIt.registerSingleton<HttpClient>(httpClient);
  }
  if (!getIt.isRegistered<WsConnectionManager>()) {
    getIt.registerLazySingleton<WsConnectionManager>(() => WsConnectionManager());
  }

  // 2. 数据库
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerLazySingleton<AppDatabase>(() => DatabaseManager.instance);
  }

  // 3. 数据处理层 (Services - 注册为 Lazy，直到真正用到且数据库 init 后才初始化)
  
  // 用户模块
  getIt.registerLazySingleton<UserService>(() => UserService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<UserSyncStatusService>(() => UserSyncStatusService(getIt<AppDatabase>()));
  
  // 好友模块
  getIt.registerLazySingleton<FriendService>(() => FriendService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<FriendVerifyService>(() => FriendVerifyService(getIt<AppDatabase>()));
  
  // 聊天模块
  getIt.registerLazySingleton<ChatConversationService>(() => ChatConversationService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<ChatMessageService>(() => ChatMessageService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<ChatUserConversationService>(() => ChatUserConversationService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<ChatSyncStatusService>(() => ChatSyncStatusService(getIt<AppDatabase>()));
  
  // 群组模块
  getIt.registerLazySingleton<GroupService>(() => GroupService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<GroupMemberService>(() => GroupMemberService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<GroupJoinRequestService>(() => GroupJoinRequestService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<GroupSyncStatusService>(() => GroupSyncStatusService(getIt<AppDatabase>()));
  
  // 其他
  getIt.registerLazySingleton<DatasyncService>(() => DatasyncService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<MediaService>(() => MediaService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<EmojiService>(() => EmojiService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<NotificationInboxService>(() => NotificationInboxService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<NotificationReadCursorService>(() => NotificationReadCursorService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<NotificationEventService>(() => NotificationEventService(getIt<AppDatabase>()));

  // 4. 业务门面层 (Business Facades - UI calls these)
  getIt.registerLazySingleton<UserBusiness>(() => UserBusiness());
  getIt.registerLazySingleton<FriendBusiness>(() => FriendBusiness());
  getIt.registerLazySingleton<GroupBusiness>(() => GroupBusiness());
  getIt.registerLazySingleton<NotificationBusiness>(() => NotificationBusiness());
  getIt.registerLazySingleton<ConversationBusiness>(() => ConversationBusiness());
  getIt.registerLazySingleton<MessageBusiness>(() => MessageBusiness());
  getIt.registerLazySingleton<MomentBusiness>(() => MomentBusiness());

  // 5. 数据同步层
  getIt.registerLazySingleton<DataSyncManager>(() => syncManager);

  print('[DI] 依赖注入配置完成');
}
