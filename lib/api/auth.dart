import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/common/config/env.dart';

/// 手机号登录
Future<BaseResponse<PhoneLoginRes>> phoneLoginApi(PhoneLoginReq data) {
  final url = '$baseUrl/api/auth/auth_public/v1/phone_login';
  return httpClient.post<PhoneLoginRes>(url, data: data.toJson(), fromJsonT: (json) => PhoneLoginRes.fromJson(json));
}

/// 邮箱密码登录
Future<BaseResponse<EmailPasswordLoginRes>> emailPasswordLoginApi(EmailPasswordLoginReq data) {
  final url = '$baseUrl/api/auth/auth_public/v1/email_password_login';
  return httpClient.post<EmailPasswordLoginRes>(url, data: data.toJson(), fromJsonT: (json) => EmailPasswordLoginRes.fromJson(json));
}

/// 认证检查
Future<BaseResponse<AuthenticationRes>> authenticationApi() {
  final url = '$baseUrl/api/auth/auth_public/v1/authentication';
  return httpClient.get<AuthenticationRes>(url, fromJsonT: (json) => AuthenticationRes.fromJson(json));
}

/// 获取邮箱验证码
Future<BaseResponse<GetEmailCodeRes>> getEmailCodeApi(GetEmailCodeReq data) {
  final url = '$baseUrl/api/auth/auth_public/v1/emailcode';
  return httpClient.post<GetEmailCodeRes>(url, data: data.toJson(), fromJsonT: (json) => GetEmailCodeRes.fromJson(json));
}

/// 邮箱注册
Future<BaseResponse<EmailRegisterRes>> emailRegisterApi(EmailRegisterReq data) {
  final url = '$baseUrl/api/auth/auth_public/v1/email_register';
  return httpClient.post<EmailRegisterRes>(url, data: data.toJson(), fromJsonT: (json) => EmailRegisterRes.fromJson(json));
}

/// 登出
Future<BaseResponse<LogoutRes>> logoutApi() {
  final url = '$baseUrl/api/auth/auth/v1/logout';
  return httpClient.post<LogoutRes>(url, data: LogoutReq().toJson(), fromJsonT: (json) => LogoutRes.fromJson(json));
}

/// 重置密码
Future<BaseResponse<ResetPasswordRes>> resetPasswordApi(ResetPasswordReq data) {
  final url = '$baseUrl/api/auth/auth_public/v1/reset_password';
  return httpClient.post<ResetPasswordRes>(url, data: data.toJson(), fromJsonT: (json) => ResetPasswordRes.fromJson(json));
}

/// 修改密码
Future<BaseResponse<UpdatePasswordRes>> updatePasswordApi(UpdatePasswordReq data) {
  final url = '$baseUrl/api/auth/auth/v1/update_password';
  return httpClient.post<UpdatePasswordRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => UpdatePasswordRes.fromJson(json),
  );
}

/// 获取登录设备列表
Future<BaseResponse<GetDevicesRes>> getDevicesApi() {
  final url = '$baseUrl/api/auth/auth/v1/devices';
  return httpClient.get<GetDevicesRes>(
    url,
    fromJsonT: (json) => GetDevicesRes.fromJson(json),
  );
}

/// 踢下线指定设备
Future<BaseResponse<KickDeviceRes>> kickDeviceApi(KickDeviceReq data) {
  final url = '$baseUrl/api/auth/auth/v1/kick_device';
  return httpClient.post<KickDeviceRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => KickDeviceRes.fromJson(json),
  );
}

