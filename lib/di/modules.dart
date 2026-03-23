import 'package:get_it/get_it.dart';

import 'core/network.dart';
import 'core/database.dart';
import 'core/services.dart';
import 'core/cache.dart';
import 'store.dart';
import 'business/user.dart';
import 'business/friend.dart';
import 'business/group.dart';
import 'business/chat.dart';
import 'business/message.dart';
import 'business/notification.dart';
import 'business/emoji.dart';
import 'business/media.dart';
import 'business/call.dart';
import 'features/auth.dart';

/// 模块注册
void registerModules(GetIt getIt) {
  // 核心层配置
  configureNetworkDependencies(getIt);
  configureDatabaseDependencies(getIt);
  configureServiceDependencies(getIt);
  configureCacheDependencies(getIt);
  configureStoreDependencies(getIt);
  
  // 业务层配置
  configureAuthDependencies(getIt); // Add this
  configureUserBusinessDependencies(getIt);
  configureFriendBusinessDependencies(getIt);
  configureGroupBusinessDependencies(getIt);
  configureChatBusinessDependencies(getIt);
  configureMessageBusinessDependencies(getIt);
  configureNotificationBusinessDependencies(getIt);
  configureEmojiBusinessDependencies(getIt);
  configureMediaBusinessDependencies(getIt);
  configureCallBusinessDependencies(getIt);
}
