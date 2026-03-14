/// 手机号登录请求
class PhoneLoginReq {
  final String phone;
  final String password;
  final String? deviceId;

  PhoneLoginReq({
    required this.phone,
    required this.password,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'password': password,
    if (deviceId != null) 'deviceId': deviceId,
  };
}

/// 手机号登录响应
class PhoneLoginRes {
  final String token;
  final String userId;

  PhoneLoginRes({
    required this.token,
    required this.userId,
  });

  factory PhoneLoginRes.fromJson(Map<String, dynamic> json) => PhoneLoginRes(
    token: json['token'] ?? '',
    userId: json['userId'] ?? '',
  );
}

/// 邮箱密码登录请求
class EmailPasswordLoginReq {
  final String email;
  final String password;
  final String? deviceId;

  EmailPasswordLoginReq({
    required this.email,
    required this.password,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    if (deviceId != null) 'deviceId': deviceId,
  };
}

/// 邮箱密码登录响应
class EmailPasswordLoginRes {
  final String token;
  final String userId;

  EmailPasswordLoginRes({
    required this.token,
    required this.userId,
  });

  factory EmailPasswordLoginRes.fromJson(Map<String, dynamic> json) => EmailPasswordLoginRes(
    token: json['token'] ?? '',
    userId: json['userId'] ?? '',
  );
}

/// 用户认证请求
class AuthenticationReq {
  final String? token;
  final String? validPath;

  AuthenticationReq({
    this.token,
    this.validPath,
  });

  Map<String, dynamic> toJson() => {
    if (token != null) 'token': token,
    if (validPath != null) 'validPath': validPath,
  };
}

/// 用户认证响应
class AuthenticationRes {
  final String userId;

  AuthenticationRes({
    required this.userId,
  });

  factory AuthenticationRes.fromJson(Map<String, dynamic> json) => AuthenticationRes(
    userId: json['userId'] ?? '',
  );
}

/// 用户登出请求
class LogoutReq {
  Map<String, dynamic> toJson() => {};
}

/// 用户登出响应
class LogoutRes {
  factory LogoutRes.fromJson(Map<String, dynamic> json) => LogoutRes();
}

/// 获取手机验证码请求
class GetPhoneCodeReq {
  final String phone;
  final String type;

  GetPhoneCodeReq({
    required this.phone,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'type': type,
  };
}

/// 获取手机验证码响应
class GetPhoneCodeRes {
  final String message;

  GetPhoneCodeRes({
    required this.message,
  });

  factory GetPhoneCodeRes.fromJson(Map<String, dynamic> json) => GetPhoneCodeRes(
    message: json['message'] ?? '',
  );
}

/// 获取邮箱验证码请求
class GetEmailCodeReq {
  final String email;
  final String type;

  GetEmailCodeReq({
    required this.email,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'type': type,
  };
}

/// 获取邮箱验证码响应
class GetEmailCodeRes {
  final String message;

  GetEmailCodeRes({
    required this.message,
  });

  factory GetEmailCodeRes.fromJson(Map<String, dynamic> json) => GetEmailCodeRes(
    message: json['message'] ?? '',
  );
}

/// 邮箱登录请求
class EmailLoginReq {
  final String email;
  final String code;
  final String? deviceId;

  EmailLoginReq({
    required this.email,
    required this.code,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
    if (deviceId != null) 'deviceId': deviceId,
  };
}

/// 邮箱登录响应
class EmailLoginRes {
  final String token;
  final String userId;

  EmailLoginRes({
    required this.token,
    required this.userId,
  });

  factory EmailLoginRes.fromJson(Map<String, dynamic> json) => EmailLoginRes(
    token: json['token'] ?? '',
    userId: json['userId'] ?? '',
  );
}

/// 忘记密码-发送重置邮件请求
class ForgotPasswordReq {
  final String email;

  ForgotPasswordReq({
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
  };
}

/// 忘记密码-发送重置邮件响应
class ForgotPasswordRes {
  final String message;

  ForgotPasswordRes({
    required this.message,
  });

  factory ForgotPasswordRes.fromJson(Map<String, dynamic> json) => ForgotPasswordRes(
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

  ResetPasswordRes({
    required this.message,
  });

  factory ResetPasswordRes.fromJson(Map<String, dynamic> json) => ResetPasswordRes(
    message: json['message'] ?? '',
  );
}
