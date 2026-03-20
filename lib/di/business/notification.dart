import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/notification/notification.dart';

/// 通知业务层依赖配置
void configureNotificationBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<NotificationBusiness>(() => NotificationBusiness());
}
