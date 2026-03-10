import 'package:beaver/core/network/api/api_client.dart';

/// 认证仓库接口定义
abstract class AuthRepository {
  Future<BaseResponse<String>> login(String username, String password);
  Future<BaseResponse<bool>> register(String username, String password);
  Future<void> logout();
}
