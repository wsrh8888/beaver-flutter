/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

/// 手机登录请求
class PhoneLoginReq {
  final String phone;
  final String password;
  final String deviceId;

  PhoneLoginReq({
    required this.phone,
    required this.password,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'password': password,
    'deviceId': deviceId,
  };
}

/// 手机登录响应
class PhoneLoginRes {
  final String token;
  final String userId;

  PhoneLoginRes({required this.token, required this.userId});

  factory PhoneLoginRes.fromJson(Map<String, dynamic> json) => PhoneLoginRes(
    token: json['token'] ?? '',
    userId: json['userId'] ?? '',
  );
}

/// 邮箱密码登录请求
class EmailPasswordLoginReq {
  final String email;
  final String password;
  final String deviceId;

  EmailPasswordLoginReq({
    required this.email,
    required this.password,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'deviceId': deviceId,
  };
}

/// 邮箱密码登录响应
class EmailPasswordLoginRes {
  final String token;
  final String userId;

  EmailPasswordLoginRes({required this.token, required this.userId});

  factory EmailPasswordLoginRes.fromJson(Map<String, dynamic> json) => EmailPasswordLoginRes(
    token: json['token'] ?? '',
    userId: json['userId'] ?? '',
  );
}

/// 认证响应
class AuthenticationRes {
  final String userId;

  AuthenticationRes({required this.userId});

  factory AuthenticationRes.fromJson(Map<String, dynamic> json) => AuthenticationRes(
    userId: json['userId'] ?? '',
  );
}

/// 邮箱注册请求
class EmailRegisterReq {
  final String email;
  final String password;
  final String code;

  EmailRegisterReq({
    required this.email,
    required this.password,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'code': code,
  };
}

/// 邮箱注册响应
class EmailRegisterRes {
  final String message;

  EmailRegisterRes({required this.message});

  factory EmailRegisterRes.fromJson(Map<String, dynamic> json) => EmailRegisterRes(
    message: json['message'] ?? '',
  );
}

/// 获取邮箱验证码请求
class GetEmailCodeReq {
  final String email;
  final String type; // register, reset_password, login, update_email

  GetEmailCodeReq({required this.email, required this.type});

  Map<String, dynamic> toJson() => {
    'email': email,
    'type': type,
  };
}

/// 获取邮箱验证码响应
class GetEmailCodeRes {
  final String message;

  GetEmailCodeRes({required this.message});

  factory GetEmailCodeRes.fromJson(Map<String, dynamic> json) => GetEmailCodeRes(
    message: json['message'] ?? '',
  );
}

/// 重置密码请求
class ResetPasswordReq {
  final String email;
  final String code;
  final String password;

  ResetPasswordReq({
    required this.email,
    required this.code,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
    'password': password,
  };
}

/// 重置密码响应
class ResetPasswordRes {
  final String message;

  ResetPasswordRes({required this.message});

  factory ResetPasswordRes.fromJson(Map<String, dynamic> json) => ResetPasswordRes(
    message: json['message'] ?? '',
  );
}

/// 登出响应
class LogoutRes {
  factory LogoutRes.fromJson(Map<String, dynamic> json) => LogoutRes();
  LogoutRes();
}

/// 登出请求
class LogoutReq {
  Map<String, dynamic> toJson() => {};
}

/// 修改密码请求
class UpdatePasswordReq {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordReq({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'oldPassword': oldPassword,
    'newPassword': newPassword,
  };
}

/// 修改密码响应
class UpdatePasswordRes {
  factory UpdatePasswordRes.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordRes();
  UpdatePasswordRes();
}

/// 设备信息
class DeviceInfo {
  final String deviceId;
  final String deviceType;
  final String deviceOs;
  final String deviceModel;
  final String deviceOsVersion;
  final String deviceName;
  final String lastLoginTime;
  final bool isOnline;
  final String lastLoginIp;

  DeviceInfo({
    required this.deviceId,
    required this.deviceType,
    required this.deviceOs,
    required this.deviceModel,
    required this.deviceOsVersion,
    required this.deviceName,
    required this.lastLoginTime,
    required this.isOnline,
    required this.lastLoginIp,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
    deviceId: json['deviceId'] ?? '',
    deviceType: json['deviceType'] ?? '',
    deviceOs: json['deviceOs'] ?? '',
    deviceModel: json['deviceModel'] ?? '',
    deviceOsVersion: json['deviceOsVersion'] ?? '',
    deviceName: json['deviceName'] ?? '',
    lastLoginTime: json['lastLoginTime'] ?? '',
    isOnline: json['isOnline'] == true,
    lastLoginIp: json['lastLoginIp'] ?? '',
  );
}

/// 获取登录设备列表响应
class GetDevicesRes {
  final List<DeviceInfo> devices;

  GetDevicesRes({required this.devices});

  factory GetDevicesRes.fromJson(Map<String, dynamic> json) => GetDevicesRes(
    devices: (json['devices'] as List?)
            ?.map((e) => DeviceInfo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

/// 踢下线设备请求
class KickDeviceReq {
  final String deviceId;

  KickDeviceReq({required this.deviceId});

  Map<String, dynamic> toJson() => {'deviceId': deviceId};
}

/// 踢下线设备响应
class KickDeviceRes {
  factory KickDeviceRes.fromJson(Map<String, dynamic> json) => KickDeviceRes();
  KickDeviceRes();
}
