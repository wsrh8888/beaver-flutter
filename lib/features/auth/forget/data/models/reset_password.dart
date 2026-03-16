class ResetPasswordRequest {
  final String email;
  final String verificationCode;
  final String password;

  const ResetPasswordRequest({
    required this.email,
    required this.verificationCode,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'verifyCode': verificationCode,
      'password': password,
    };
  }
}

class SendVerificationCodeRequest {
  final String email;
  final String type;

  const SendVerificationCodeRequest({
    required this.email,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'type': type,
    };
  }
}
