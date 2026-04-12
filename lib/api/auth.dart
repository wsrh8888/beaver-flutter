import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/common/config/env.dart';

/// 手机号登录
Future<BaseResponse<PhoneLoginRes>> phoneLoginApi(PhoneLoginReq data) {
  final url = '$baseUrl/api/auth/phone_login';
  return httpClient.post<PhoneLoginRes>(url, data: data.toJson(), fromJsonT: (json) => PhoneLoginRes.fromJson(json));
}

/// 邮箱密码登录
Future<BaseResponse<EmailPasswordLoginRes>> emailPasswordLoginApi(EmailPasswordLoginReq data) {
  final url = '$baseUrl/api/auth/email_password_login';
  return httpClient.post<EmailPasswordLoginRes>(url, data: data.toJson(), fromJsonT: (json) => EmailPasswordLoginRes.fromJson(json));
}

/// 认证检查
Future<BaseResponse<AuthenticationRes>> authenticationApi() {
  final url = '$baseUrl/api/auth/authentication';
  return httpClient.get<AuthenticationRes>(url, fromJsonT: (json) => AuthenticationRes.fromJson(json));
}

/// 获取邮箱验证码
Future<BaseResponse<GetEmailCodeRes>> getEmailCodeApi(GetEmailCodeReq data) {
  final url = '$baseUrl/api/auth/emailcode';
  return httpClient.post<GetEmailCodeRes>(url, data: data.toJson(), fromJsonT: (json) => GetEmailCodeRes.fromJson(json));
}

/// 邮箱注册
Future<BaseResponse<EmailRegisterRes>> emailRegisterApi(EmailRegisterReq data) {
  final url = '$baseUrl/api/auth/email_register';
  return httpClient.post<EmailRegisterRes>(url, data: data.toJson(), fromJsonT: (json) => EmailRegisterRes.fromJson(json));
}

/// 登出
Future<BaseResponse<LogoutRes>> logoutApi() {
  final url = '$baseUrl/api/auth/logout';
  return httpClient.post<LogoutRes>(url, data: LogoutReq().toJson(), fromJsonT: (json) => LogoutRes.fromJson(json));
}

/// 重置密码
Future<BaseResponse<ResetPasswordRes>> resetPasswordApi(ResetPasswordReq data) {
  final url = '$baseUrl/api/auth/reset_password';
  return httpClient.post<ResetPasswordRes>(url, data: data.toJson(), fromJsonT: (json) => ResetPasswordRes.fromJson(json));
}

