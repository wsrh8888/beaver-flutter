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
