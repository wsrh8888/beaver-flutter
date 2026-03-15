import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/common/config/env.dart';

/// 手机号登录
Future<BaseResponse<PhoneLoginRes>> phoneLoginApi(PhoneLoginReq data) {
  const url = '/api/auth/phone_login';
  return httpClient.post<PhoneLoginRes>(url, data: data.toJson(), fromJsonT: (json) => PhoneLoginRes.fromJson(json));
}

/// 邮箱密码登录
Future<BaseResponse<EmailPasswordLoginRes>> emailPasswordLoginApi(EmailPasswordLoginReq data) {
  const url = '/api/auth/email_password_login';
  return httpClient.post<EmailPasswordLoginRes>(url, data: data.toJson(), fromJsonT: (json) => EmailPasswordLoginRes.fromJson(json));
}

/// 认证检查
Future<BaseResponse<AuthenticationRes>> authenticationApi() {
  const url = '/api/auth/authentication';
  return httpClient.get<AuthenticationRes>(url, fromJsonT: (json) => AuthenticationRes.fromJson(json));
}

/// 获取邮箱验证码
Future<BaseResponse<GetEmailCodeRes>> getEmailCodeApi(GetEmailCodeReq data) {
  const url = '/api/auth/emailcode';
  return httpClient.post<GetEmailCodeRes>(url, data: data.toJson(), fromJsonT: (json) => GetEmailCodeRes.fromJson(json));
}

/// 邮箱注册
Future<BaseResponse<EmailRegisterRes>> emailRegisterApi(EmailRegisterReq data) {
  const url = '/api/auth/email_register';
  return httpClient.post<EmailRegisterRes>(url, data: data.toJson(), fromJsonT: (json) => EmailRegisterRes.fromJson(json));
}

/// 登出
Future<BaseResponse<LogoutRes>> logoutApi() {
  const url = '/api/auth/logout';
  return httpClient.post<LogoutRes>(url, data: LogoutReq().toJson(), fromJsonT: (json) => LogoutRes.fromJson(json));
}
