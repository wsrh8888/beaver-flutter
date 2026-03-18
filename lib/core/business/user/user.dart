import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
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
   * @description 获取 UI 格式的用户信息 (模仿 Repository 逻辑)
   */
  Future<UserInfo> getMyUserInfo() async {
    final user = await _userService.db.select(_userService.db.users).getSingleOrNull();
    if (user != null) {
      return UserInfo(
        userId: user.userId,
        nickname: user.nickName,
        avatar: user.avatar,
      );
    }
    return const UserInfo(
      userId: '未设置',
      nickname: 'Beaver',
    );
  }
}