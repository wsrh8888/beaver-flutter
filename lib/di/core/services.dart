import 'package:get_it/get_it.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/core/datasync/emoji/sync.dart';

/// 数据服务层依赖配置
void configureServiceDependencies(GetIt getIt) {
  getIt.registerLazySingleton<UserService>(() => const UserService());
  getIt.registerLazySingleton<UserSyncStatusService>(
    () => const UserSyncStatusService(),
  );

  getIt.registerLazySingleton<FriendService>(() => const FriendService());
  getIt.registerLazySingleton<FriendVerifyService>(
    () => const FriendVerifyService(),
  );

  getIt.registerLazySingleton<ChatConversationService>(
    () => const ChatConversationService(),
  );
  getIt.registerLazySingleton<ChatMessageService>(
    () => const ChatMessageService(),
  );
  getIt.registerLazySingleton<ChatUserConversationService>(
    () => const ChatUserConversationService(),
  );
  getIt.registerLazySingleton<ChatSyncStatusService>(
    () => const ChatSyncStatusService(),
  );
  getIt.registerLazySingleton<ChatMessageMediaService>(
    () => const ChatMessageMediaService(),
  );

  getIt.registerLazySingleton<GroupService>(() => const GroupService());
  getIt.registerLazySingleton<GroupMemberService>(
    () => const GroupMemberService(),
  );
  getIt.registerLazySingleton<GroupJoinRequestService>(
    () => const GroupJoinRequestService(),
  );
  getIt.registerLazySingleton<GroupSyncStatusService>(
    () => const GroupSyncStatusService(),
  );

  getIt.registerLazySingleton<DatasyncService>(() => const DatasyncService());
  getIt.registerLazySingleton<MediaService>(() => const MediaService());

  getIt.registerLazySingleton<EmojiService>(() => const EmojiService());
  getIt.registerLazySingleton<EmojiCollectService>(
    () => const EmojiCollectService(),
  );
  getIt.registerLazySingleton<EmojiPackageService>(
    () => const EmojiPackageService(),
  );
  getIt.registerLazySingleton<EmojiPackageCollectService>(
    () => const EmojiPackageCollectService(),
  );
  getIt.registerLazySingleton<EmojiPackageEmojiService>(
    () => const EmojiPackageEmojiService(),
  );
  getIt.registerLazySingleton<EmojiSync>(() => EmojiSync());
  getIt.registerLazySingleton<NotificationInboxService>(
    () => const NotificationInboxService(),
  );
  getIt.registerLazySingleton<NotificationReadCursorService>(
    () => const NotificationReadCursorService(),
  );
  getIt.registerLazySingleton<NotificationEventService>(
    () => const NotificationEventService(),
  );
}
