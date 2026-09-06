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
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('repo-user-profile');

class ProfileRepository {
  final UserRepositoryInterface _userRepository;

  ProfileRepository({UserRepositoryInterface? userRepository}) 
    : _userRepository = userRepository ?? getIt<UserRepositoryInterface>();

  Future<profile_model.UserInfo> getUserInfo() async {
    try {

    final user = await _userRepository.getMyUserInfo();
    return profile_model.UserInfo(
      userId: user.userId,
      nickName: user.nickname,
      fileName: user.avatar ?? '',
      email: user.email ?? '',
      gender: user.gender,
      abstract: user.abstract,
    );
    } catch (e, st) {
      _logger.warn({'text':'ProfileRepository.getUserInfo 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<bool> updateUserInfo(Map<String, dynamic> updates) async {
    try {

    return _userRepository.updateProfile(
      nickname: updates['nickName'],
      avatar: updates['fileName'],
      abstract: updates['abstract'],
      gender: updates['gender'],
    );
    } catch (e, st) {
      _logger.warn({'text':'ProfileRepository.updateUserInfo 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<bool> sendEmailCode(String email) async {
    try {

    return _userRepository.getEmailCode(email, 'update_email');
    } catch (e, st) {
      _logger.warn({'text':'ProfileRepository.sendEmailCode 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<bool> updateEmail(String email, String code) async {
    try {

    return _userRepository.updateEmail(email, code);
    } catch (e, st) {
      _logger.warn({'text':'ProfileRepository.updateEmail 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}

