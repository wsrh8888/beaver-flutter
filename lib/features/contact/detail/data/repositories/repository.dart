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

import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/friend/friend.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/contact/detail/data/models/user_info.dart' as detail_model;
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/types/business/user.dart';
import 'package:beaver/types/business/chat.dart';

class DetailRepository {
  final FriendRepositoryInterface _friendRepository;
  final UserRepositoryInterface _userRepository;
  final ConversationRepositoryInterface _conversationRepository;
  final FriendService _friendService;
  final FriendBusiness _friendBusiness;

  DetailRepository({
    FriendRepositoryInterface? friendRepository,
    UserRepositoryInterface? userRepository,
    ConversationRepositoryInterface? conversationRepository,
    FriendService? friendService,
    FriendBusiness? friendBusiness,
  })  : _friendRepository = friendRepository ?? getIt<FriendRepositoryInterface>(),
        _userRepository = userRepository ?? getIt<UserRepositoryInterface>(),
        _conversationRepository = conversationRepository ?? getIt<ConversationRepositoryInterface>(),
        _friendService = friendService ?? getIt<FriendService>(),
        _friendBusiness = friendBusiness ?? getIt<FriendBusiness>();

  Future<String> _getRemarkName(String userId) async {
    final myUserId = DatabaseManager.currentUserId ?? '';
    if (myUserId.isEmpty) return '';

    final friend = await _friendService.getFriendByPeerId(myUserId, userId);
    if (friend == null) return '';

    return friend.sendUserId == myUserId
        ? (friend.sendUserNotice ?? '')
        : (friend.revUserNotice ?? '');
  }

  Future<detail_model.UserInfo> getUserInfo(String userId) async {
    final user = await _userRepository.getUserProfile(userId);
    final conversationId = await _conversationRepository.getConversationIdByPeerId(userId);
    final remarkName = await _getRemarkName(userId);

    if (user != null) {
      return detail_model.UserInfo(
          userId: user.userId,
          nickname: user.nickName,
          fileName: user.avatar ?? '',
          remarkName: remarkName,
          signature: user.abstract,
          gender: user.gender == 1 ? 'male' : 'female',
          location: '',
          age: '',
          constellation: '',
          occupation: '',
          education: '',
          hobbies: '',
          photos: [],
          conversationId: conversationId,
          source: 'search',
        );
    }
    return detail_model.UserInfo(
      userId: userId,
      nickname: '未知用户',
      fileName: '',
      remarkName: remarkName,
      signature: '',
      gender: 'male',
      location: '',
      age: '',
      constellation: '',
      occupation: '',
      education: '',
      hobbies: '',
      photos: [],
      conversationId: conversationId,
      source: 'search',
    );
  }

  Future<bool> updateRemarkName(String userId, String remarkName) async {
    return _friendBusiness.updateRemarkName(userId, remarkName);
  }

  Future<bool> deleteFriend(String userId) async {
    await _friendRepository.deleteFriend(userId);
    return true;
  }
}
