import 'package:beaver/api/auth.dart';
import 'package:beaver/api/user.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/types/api/user.dart';
import 'package:beaver/types/business/user.dart';

/// 用户业务逻辑
class UserBusiness {
  final _userService = getIt<UserService>();

  /**
   * @description 根据 userId 获取用户信息 (Drift Model)
   */
  Future<User?> getUserProfile(String userId) async {
    return _userService.getUserByUserId(userId);
  }

  /**
   * @description 获取 UI 格式的用户信息
   */
  Future<UserInfo> getMyUserInfo() async {
    final user = await _userService.db.select(_userService.db.users).getSingleOrNull();
    if (user != null) {
      return UserInfo(
        userId: user.userId,
        nickname: user.nickName,
        avatar: user.avatar,
        abstract: user.abstract,
        email: user.email,
        gender: user.gender,
      );
    }
    return const UserInfo(
      userId: '未设置',
      nickname: 'Beaver',
    );
  }

  /**
   * @description 更新用户基础资料
   */
  Future<bool> updateProfile({
    String? nickname,
    String? avatar,
    String? abstract,
    int? gender,
  }) async {
    final res = await updateInfoApi(IUpdateInfoReq(
      nickName: nickname,
      avatar: avatar,
      abstract: abstract,
      gender: gender,
    ));

    if (res.code == 0) {
      final currentUser = await _userService.db.select(_userService.db.users).getSingleOrNull();
      if (currentUser != null) {
        await _userService.updateUser(
          userId: currentUser.userId,
          nickName: nickname,
          avatar: avatar,
          abstract: abstract,
          gender: gender,
        );
      }
      return true;
    }
    return false;
  }

  /**
   * @description 发送邮箱验证码
   */
  Future<bool> getEmailCode(String email, String type) async {
    final res = await getEmailCodeApi(GetEmailCodeReq(email: email, type: type));
    return res.code == 0;
  }

  /**
   * @description 更新邮箱
   */
  Future<bool> updateEmail(String email, String code) async {
    final res = await updateEmailApi(IUpdateEmailReq(email: email, code: code));
    if (res.code == 0) {
      final currentUser = await _userService.db.select(_userService.db.users).getSingleOrNull();
      if (currentUser != null) {
        await _userService.updateUser(userId: currentUser.userId, email: email);
      }
      return true;
    }
    return false;
  }
}