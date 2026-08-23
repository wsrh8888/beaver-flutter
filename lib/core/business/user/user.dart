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

  // 用户数据更新流 (对标 PC 的 Notification 机制)
  final _userUpdateController = StreamController<List<String>>.broadcast();
  Stream<List<String>> get userUpdateStream => _userUpdateController.stream;

  void notifyUserUpdate(List<String> userIds) {
    _userUpdateController.add(userIds);
  }

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

    // 2. 从数据库查询该用户
    final User? dbUser = await _userService.getUserByUserId(userId);

    if (dbUser == null) {
      return UserInfo(userId: userId, nickname: 'Beaver');
    }

    return UserInfo(
      userId: dbUser.userId,
      nickname: dbUser.nickName ?? 'Beaver',
      avatar: dbUser.avatar,
      abstract: dbUser.abstract,
      email: dbUser.email,
      phone: dbUser.phone,
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

        // 发送更新流
        _profileUpdateController.add(await getMyUserInfo());
      }
    } catch (e) {
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
            phone: u['phone'] ?? '',
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

  /**
   * 按版本号同步用户资料 (对标 PC handleTableUpdates)
   */
  Future<void> handleTableUpdates(String targetId, int version) async {
    try {
      final res = await userSyncApi(
        IUserSyncReq(
          userVersions: [IUserVersionItem(userId: targetId, version: version)],
        ),
      );

      if (res.code == 0 && res.result != null && res.result!.users.isNotEmpty) {
        await _userService.batchCreate(res.result!.users);
        notifyUserUpdate([targetId]);
      }
    } catch (e) {
    }
  }
}
