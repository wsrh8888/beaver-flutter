import 'package:beaver/features/auth/forget/data/models/reset_password.dart';

class ForgetRepository {
  Future<bool> sendVerificationCode(SendVerificationCodeRequest request) async {
    // 模拟发送验证码
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> resetPassword(ResetPasswordRequest request) async {
    // 模拟重置密码
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
