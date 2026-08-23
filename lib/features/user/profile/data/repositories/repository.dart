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

import 'package:beaver/di/injection.dart';
import 'package:beaver/features/user/profile/data/models/profile.dart' as profile_model;
import 'package:beaver/types/business/user.dart';

class ProfileRepository {
  final UserRepositoryInterface _userRepository;

  ProfileRepository({UserRepositoryInterface? userRepository}) 
    : _userRepository = userRepository ?? getIt<UserRepositoryInterface>();

  Future<profile_model.UserInfo> getUserInfo() async {
    final user = await _userRepository.getMyUserInfo();
    return profile_model.UserInfo(
      userId: user.userId,
      nickName: user.nickname,
      fileName: user.avatar ?? '',
      email: user.email ?? '',
      gender: user.gender,
      abstract: user.abstract,
    );
  }

  Future<bool> updateUserInfo(Map<String, dynamic> updates) async {
    return _userRepository.updateProfile(
      nickname: updates['nickName'],
      avatar: updates['fileName'],
      abstract: updates['abstract'],
      gender: updates['gender'],
    );
  }

  Future<bool> sendEmailCode(String email) async {
    return _userRepository.getEmailCode(email, 'update_email');
  }

  Future<bool> updateEmail(String email, String code) async {
    return _userRepository.updateEmail(email, code);
  }
}

