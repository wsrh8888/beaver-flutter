import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/types/business/message.dart';

/// 消息业务层依赖配置
void configureMessageBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<MessageBusiness>(() => MessageBusiness());
  
  // 业务接口注册
  getIt.registerLazySingleton<MessageRepositoryInterface>(() => MessageBusiness());
}
