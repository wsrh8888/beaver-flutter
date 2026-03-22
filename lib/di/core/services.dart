import 'package:get_it/get_it.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/core/datasync/emoji/sync.dart';

/// 数据服务层依赖配置
void configureServiceDependencies(GetIt getIt) {
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
  
  // 其他服务
  getIt.registerLazySingleton<DatasyncService>(() => DatasyncService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<MediaService>(() => MediaService(getIt<AppDatabase>()));
  // 表情模块服务
  getIt.registerLazySingleton<EmojiService>(() => EmojiService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<EmojiCollectService>(() => EmojiCollectService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<EmojiPackageService>(() => EmojiPackageService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<EmojiPackageCollectService>(() => EmojiPackageCollectService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<EmojiPackageEmojiService>(() => EmojiPackageEmojiService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<EmojiSync>(() => EmojiSync());
  getIt.registerLazySingleton<NotificationInboxService>(() => NotificationInboxService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<NotificationReadCursorService>(() => NotificationReadCursorService(getIt<AppDatabase>()));
  getIt.registerLazySingleton<NotificationEventService>(() => NotificationEventService(getIt<AppDatabase>()));
}
