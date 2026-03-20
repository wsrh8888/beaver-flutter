import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/types/business/chat.dart';

/// 聊天业务层依赖配置
void configureChatBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<ConversationBusiness>(() => ConversationBusiness());
  
  // 业务接口注册
  getIt.registerLazySingleton<ConversationRepositoryInterface>(() => ConversationBusiness());
}
