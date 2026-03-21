import 'dart:async';
import 'package:beaver/api/auth.dart';
import 'package:beaver/api/user.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/types/api/user.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/business/user.dart';
import 'package:beaver/shared/utils/storage_util.dart';

/// 用户业务逻辑
class UserBusiness implements UserRepositoryInterface {
  final _userService = getIt<UserService>();

  // 个人资料更新流，用于通知全局 Store
  final _profileUpdateController = StreamController<UserInfo>.broadcast();
  Stream<UserInfo> get profileUpdateStream => _profileUpdateController.stream;

  /**
   * @description 根据 userId 获取用户信息 (Drift Model)
   */
  Future<User?> getUserProfile(String userId) async {
    return _userService.getUserByUserId(userId);
  }

  /**
   * @description 获取当前登录者的用户信息
   */
  Future<UserInfo> getMyUserInfo() async {
    // 1. 从本地存储获取当前登录的 userId
    final userId = StorageUtil.getString('userId') ?? '';

    if (userId.isEmpty) {
      return const UserInfo(userId: '', nickname: '未登录');
    }

    // 2. 从数据库查询该用户 (重命名为 dbUser 避免与类名冲突并显式检查)
    final dbUser = await _userService.getUserByUserId(userId);

    if (dbUser == null) {
      print('UserBusiness: 数据库中未找到该用户，尝试从服务器同步...');
      return UserInfo(userId: userId, nickname: 'Beaver');
    }

    print('UserBusiness: 数据库命中 ${dbUser.userId}');
    return UserInfo(
      userId: dbUser.userId,
      nickname: dbUser.nickName ?? 'Beaver',
      avatar: dbUser.avatar,
      abstract: dbUser.abstract,
      email: dbUser.email,
      gender: dbUser.gender ?? 0,
    );
  }

  /**
   * @description: 同步当前用户的资料并保存到数据库 (对标 PC sync logic)
   */
  Future<void> syncMyProfile() async {
    final userId = StorageUtil.getString('userId') ?? '';
    if (userId.isEmpty) return;

    try {
      // 调用同步接口 (由于是强制同步个人资料，传入基础版本号 0 或当前版本)
      final res = await userSyncApi(
        IUserSyncReq(
          userVersions: [IUserVersionItem(userId: userId, version: 0)],
        ),
      );

      if (res.code == 0 && res.result != null && res.result!.users.isNotEmpty) {
        // 保存同步回来的用户信息到数据库
        await _userService.batchCreate(res.result!.users);
        print('UserBusiness: 个人资料同步完成并入库');

        // 发送更新流
        _profileUpdateController.add(await getMyUserInfo());
      }
    } catch (e) {
      print('UserBusiness: 同步个人资料出错: $e');
    }
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
    final res = await updateInfoApi(
      IUpdateInfoReq(
        nickName: nickname,
        avatar: avatar,
        abstract: abstract,
        gender: gender,
      ),
    );

    if (res.code == 0) {
      final currentUser = await _userService.db
          .select(_userService.db.users)
          .getSingleOrNull();
      if (currentUser != null) {
        await _userService.updateUser(
          userId: currentUser.userId,
          nickName: nickname,
          avatar: avatar,
          abstract: abstract,
          gender: gender,
        );
        // 通知全局 Store 更新
        _profileUpdateController.add(await getMyUserInfo());
      }
      return true;
    }
    return false;
  }

  /**
   * @description 发送邮箱验证码
   */
  Future<bool> getEmailCode(String email, String type) async {
    final res = await getEmailCodeApi(
      GetEmailCodeReq(email: email, type: type),
    );
    return res.code == 0;
  }

  /**
   * @description 更新邮箱
   */
  Future<bool> updateEmail(String email, String code) async {
    final res = await updateEmailApi(IUpdateEmailReq(email: email, code: code));
    if (res.code == 0) {
      final currentUser = await _userService.db
          .select(_userService.db.users)
          .getSingleOrNull();
      if (currentUser != null) {
        await _userService.updateUser(userId: currentUser.userId, email: email);
        // 通知全局 Store 更新
        _profileUpdateController.add(await getMyUserInfo());
      }
      return true;
    }
    return false;
  }

  /**
   * @description 获取所有用户基本信息 (用于 ContactStore 初始化)
   */
  Future<List<UserInfo>> getAllUsers() async {
    final users = await _userService.getAllUsers();
    return users
        .map(
          (u) => UserInfo(
            userId: u['userId'],
            nickname: u['nickName'] ?? '',
            avatar: u['avatar'] ?? '',
            abstract: u['abstract'] ?? '',
            email: u['email'] ?? '',
            gender: u['gender'] ?? 0,
          ),
        )
        .toList();
  }

  /**
   * @description 批量获取用户基本信息
   */
  Future<List<UserInfo>> getUsersBasicInfo(List<String> userIds) async {
    final users = await _userService.getUsersBasicInfo(userIds);
    return users
        .map(
          (u) => UserInfo(
            userId: u['userId'],
            nickname: u['nickName'] ?? '',
            avatar: u['avatar'] ?? '',
          ),
        )
        .toList();
  }
}
