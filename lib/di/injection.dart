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
  // 1. 基础工具初始化
  // StorageUtil.init() 在 main.dart 中已调用，这里可省

  // 2. 核心网络客户端
  if (!getIt.isRegistered<HttpClient>()) {
    getIt.registerSingleton<HttpClient>(httpClient);
  }
  if (!getIt.isRegistered<WsConnectionManager>()) {
    getIt.registerLazySingleton<WsConnectionManager>(
      () => WsConnectionManager(),
    );
  }

  // 3. 数据库
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerLazySingleton<AppDatabase>(() => DatabaseManager.instance);
  }

  // 4. 数据处理层 (Services - Direct DB Access)
  final db = getIt<AppDatabase>();

  // 用户模块
  getIt.registerLazySingleton<UserService>(() => UserService(db));
  getIt.registerLazySingleton<UserSyncStatusService>(
    () => UserSyncStatusService(db),
  );

  // 好友模块
  getIt.registerLazySingleton<FriendService>(() => FriendService(db));
  getIt.registerLazySingleton<FriendVerifyService>(
    () => FriendVerifyService(db),
  );

  // 聊天模块
  getIt.registerLazySingleton<ChatConversationService>(
    () => ChatConversationService(db),
  );
  getIt.registerLazySingleton<ChatMessageService>(() => ChatMessageService(db));
  getIt.registerLazySingleton<ChatUserConversationService>(
    () => ChatUserConversationService(db),
  );
  getIt.registerLazySingleton<ChatSyncStatusService>(
    () => ChatSyncStatusService(db),
  );

  // 群组模块
  getIt.registerLazySingleton<GroupService>(() => GroupService(db));
  getIt.registerLazySingleton<GroupMemberService>(() => GroupMemberService(db));
  getIt.registerLazySingleton<GroupJoinRequestService>(
    () => GroupJoinRequestService(db),
  );
  getIt.registerLazySingleton<GroupSyncStatusService>(
    () => GroupSyncStatusService(db),
  );

  // 其他
  getIt.registerLazySingleton<DatasyncService>(() => DatasyncService(db));
  getIt.registerLazySingleton<MediaService>(() => MediaService(db));
  getIt.registerLazySingleton<EmojiService>(() => EmojiService(db));
  getIt.registerLazySingleton<NotificationInboxService>(
    () => NotificationInboxService(db),
  );
  getIt.registerLazySingleton<NotificationReadCursorService>(
    () => NotificationReadCursorService(db),
  );
  getIt.registerLazySingleton<NotificationEventService>(
    () => NotificationEventService(db),
  );

  // 5. 业务门面层 (Business Facades - UI calls these)
  getIt.registerLazySingleton<UserBusiness>(() => UserBusiness());
  getIt.registerLazySingleton<FriendBusiness>(() => FriendBusiness());
  getIt.registerLazySingleton<GroupBusiness>(() => GroupBusiness());
  getIt.registerLazySingleton<NotificationBusiness>(
    () => NotificationBusiness(),
  );
  getIt.registerLazySingleton<ConversationBusiness>(
    () => ConversationBusiness(),
  );
  getIt.registerLazySingleton<MessageBusiness>(() => MessageBusiness());
  getIt.registerLazySingleton<MomentBusiness>(() => MomentBusiness());

  // 6. 数据同步层
  getIt.registerLazySingleton<DataSyncManager>(() => syncManager);

  print('[DI] 依赖注入配置完成');
}
