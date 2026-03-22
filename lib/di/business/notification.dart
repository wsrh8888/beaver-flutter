import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/notification/event.dart';
import 'package:beaver/core/business/notification/inbox.dart';
import 'package:beaver/core/business/notification/read_cursor.dart';

/// 通知业务层依赖配置
void configureNotificationBusinessDependencies(GetIt getIt) {
  // 业务模块
  getIt.registerLazySingleton<NotificationEventBusiness>(() => NotificationEventBusiness());
  getIt.registerLazySingleton<NotificationInboxBusiness>(() => NotificationInboxBusiness());
  getIt.registerLazySingleton<NotificationReadCursorBusiness>(() => NotificationReadCursorBusiness());
}
