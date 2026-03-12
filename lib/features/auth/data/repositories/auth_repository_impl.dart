import 'package:beaver/core/database/database.dart';
import 'package:beaver/core/network/api/api_client.dart';
import 'package:beaver/core/network/request/request.dart';
import 'package:beaver/core/network/websocket/websocket.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/auth/data/repositories/auth_repository.dart';
import 'package:beaver/shared/utils/storage_util.dart';

/// 认证仓库实现 (对标桌面端 Login 相关逻辑)
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<BaseResponse<String>> login(String username, String password) async {
    // 1. 调用登录 API
    final response = await apiClient.post<String>(
      '/auth/login',
      data: {'username': username, 'password': password},
      fromJsonT: (json) => json['token'] as String, // 假设返回体包含 token
    );

    // 2. 登录成功逻辑
    if (response.code == 0 && response.result != null) {
      final token = response.result!;
      final userId = response.msg; // 假设用 msg 带回 userId 或者在 result 里

      // a. 保存 Token 到本地
      await StorageUtil.setString('token', token);
      await StorageUtil.setString('userId', userId);

      // b. 更新 ApiClient 内存缓存 (对标 ajax.ts 的 cachedToken)
      apiClient.updateToken(token);

      // c. 初始化该账号专用的本地数据库 (对标桌面端 DBManager.init(userId))
      await DatabaseManager.init(userId);

      // d. 连接 WS，连接成功后自动执行 dataSyncManager.autoSync (对标 desktop MessageManager.onWsConnect)
      getIt<WsConnectionManager>().connectWithToken(token);

      print('[Auth] 登录成功，用户: $userId, Token: $token');
    }

    return response;
  }

  @override
  Future<BaseResponse<bool>> register(String username, String password) async {
    return await apiClient.post<bool>(
      '/auth/register',
      data: {'username': username, 'password': password},
      fromJsonT: (json) => true,
    );
  }

  @override
  Future<void> logout() async {
    getIt<WsConnectionManager>().disconnect();
    await StorageUtil.remove('token');
    await StorageUtil.remove('userId');
    await DatabaseManager.close();
  }
}
