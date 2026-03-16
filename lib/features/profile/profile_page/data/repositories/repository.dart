import 'package:beaver/features/profile/profile_page/data/models/profile.dart';

class ProfileRepository {
  Future<UserInfo> getUserInfo() async {
    // 模拟获取用户信息
    await Future.delayed(const Duration(seconds: 1));
    return UserInfo(
      userId: '123456',
      nickName: '张三',
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
      email: 'zhangsan@example.com',
      gender: 1,
      abstract: '这个人很懒，什么都没写~',
    );
  }

  Future<bool> updateUserInfo(Map<String, dynamic> updates) async {
    // 模拟更新用户信息
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> sendEmailCode(String email) async {
    // 模拟发送验证码
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> updateEmail(String email, String code) async {
    // 模拟更新邮箱
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
