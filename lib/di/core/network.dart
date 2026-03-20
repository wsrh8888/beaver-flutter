import 'package:get_it/get_it.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';

/// 网络相关依赖配置
void configureNetworkDependencies(GetIt getIt) {
  // 核心网络客户端
  if (!getIt.isRegistered<HttpClient>()) {
    getIt.registerSingleton<HttpClient>(httpClient);
  }
  if (!getIt.isRegistered<WsConnectionManager>()) {
    getIt.registerLazySingleton<WsConnectionManager>(() => WsConnectionManager());
  }
}
