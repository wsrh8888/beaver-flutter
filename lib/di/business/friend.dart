import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/business/friend/friend_verify.dart';
import 'package:beaver/types/business/contact.dart';

/// 好友业务层依赖配置
void configureFriendBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<FriendBusiness>(() => FriendBusiness());
  getIt.registerLazySingleton<FriendVerifyBusiness>(() => FriendVerifyBusiness());
  
  // 业务接口注册
  getIt.registerLazySingleton<FriendRepositoryInterface>(
    () => getIt<FriendBusiness>(),
  );
}
