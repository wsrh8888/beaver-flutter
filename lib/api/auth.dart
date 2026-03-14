import 'package:beaver/common/request/api_client.dart';
import 'package:beaver/common/request/response.dart';

/// 认证相关接口 (对标 desktop render/api/auth.ts)
class AuthApi {
  const AuthApi(this._client);
  final ApiClient _client;

  /// 手机号登录
  Future<BaseResponse<T>> phoneLogin<T>(Map<String, dynamic> data, T Function(dynamic) fromJsonT) {
    return _client.post<T>('/api/auth/phone_login', data: data, fromJsonT: fromJsonT);
  }

  /// 邮箱密码登录
  Future<BaseResponse<T>> emailPasswordLogin<T>(
    Map<String, dynamic> data,
    T Function(dynamic) fromJsonT,
  ) {
    return _client.post<T>('/api/auth/email_password_login', data: data, fromJsonT: fromJsonT);
  }

  /// 认证检查
  Future<BaseResponse<T>> authentication<T>([T Function(dynamic)? fromJsonT]) {
    return _client.get<T>('/api/auth/authentication', fromJsonT: fromJsonT);
  }

  /// 登出
  Future<BaseResponse<T>> logout<T>(Map<String, dynamic>? data, [T Function(dynamic)? fromJsonT]) {
    return _client.post<T>('/api/auth/logout', data: data, fromJsonT: fromJsonT);
  }
}
