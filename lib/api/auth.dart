import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/common/config/env.dart';

/// 手机号登录
Future<BaseResponse<PhoneLoginRes>> phoneLoginApi(PhoneLoginReq data) {
  final url = '$baseUrl/api/auth/phone_login';
  return httpClient.post<PhoneLoginRes>(url, data: data.toJson(), fromJsonT: PhoneLoginRes.fromJson);
}

/// 邮箱密码登录
Future<BaseResponse<EmailPasswordLoginRes>> emailPasswordLoginApi(EmailPasswordLoginReq data) {
  final url = '$baseUrl/api/auth/email_password_login';
  return httpClient.post<EmailPasswordLoginRes>(url, data: data.toJson(), fromJsonT: EmailPasswordLoginRes.fromJson);
}

/// 认证检查
Future<BaseResponse<AuthenticationRes>> authenticationApi() {
  final url = '$baseUrl/api/auth/authentication';
  return httpClient.get<AuthenticationRes>(url, fromJsonT: AuthenticationRes.fromJson);
}

/// 登出
Future<BaseResponse<LogoutRes>> logoutApi() {
  final url = '$baseUrl/api/auth/logout';
  return httpClient.post<LogoutRes>(url, data: LogoutReq().toJson(), fromJsonT: LogoutRes.fromJson);
}
