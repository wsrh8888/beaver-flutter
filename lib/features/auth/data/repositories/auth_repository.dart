import 'package:beaver/common/request/request.dart';

/// 认证仓库接口定义
abstract class AuthRepository {
  Future<BaseResponse<String>> login(String username, String password);
  Future<BaseResponse<bool>> register(String email, String password, String code);
  Future<BaseResponse<bool>> getEmailCode(String email);
  Future<void> logout();
}
