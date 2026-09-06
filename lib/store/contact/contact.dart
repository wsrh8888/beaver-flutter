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

import 'package:beaver/common/logger/index.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('store-contact');

class ContactStoreState extends Equatable {
  final Map<String, UserInfo> userMap;
  final int version;

  const ContactStoreState({this.userMap = const {}, this.version = 0});

  ContactStoreState copyWith({Map<String, UserInfo>? userMap, int? version}) {
    return ContactStoreState(
      userMap: userMap ?? this.userMap,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [userMap, version];
}

class ContactStore extends Cubit<ContactStoreState> {
  final UserBusiness _userBusiness;
  StreamSubscription? _userBusinessSubscription;
  Timer? _userUpdateDebounceTimer;
  final Set<String> _pendingUserIds = <String>{};

  ContactStore({UserBusiness? userBusiness})
    : _userBusiness = userBusiness ?? getIt<UserBusiness>(),
      super(const ContactStoreState()) {
    _userBusinessSubscription = _userBusiness.userUpdateStream.listen((
      userIds,
    ) {
      _pendingUserIds.addAll(userIds.where((id) => id.trim().isNotEmpty));
      _userUpdateDebounceTimer?.cancel();
      _userUpdateDebounceTimer = Timer(const Duration(milliseconds: 200), () {
        final ids = _pendingUserIds.toList(growable: false);
        _pendingUserIds.clear();
        updateContactsByIds(ids);
      });
    });
  }

  @override
  Future<void> close() {
    _userBusinessSubscription?.cancel();
    _userUpdateDebounceTimer?.cancel();
    return super.close();
  }

  Future<void> init() async {
    _logger.info({'text': '初始化联系人', 'data': {}});
    final users = await _userBusiness.getAllUsers();
    final nextMap = <String, UserInfo>{};
    for (final user in users) {
      nextMap[user.userId] = user;
    }
    _logger.info({'text': '联系人初始化完成', 'data': {'count': nextMap.length}});
    emit(state.copyWith(userMap: nextMap, version: state.version + 1));
  }

  void updateContact(
    String userId,
    UserInfo contactInfo, {
    bool force = false,
  }) {
    _logger.info({'text': '更新单个联系人', 'data': {'userId': userId, 'force': force}});
    final existing = state.userMap[userId];

    if (existing != null) {
      final merged = UserInfo(
        userId: userId,
        nickname: contactInfo.nickname.isNotEmpty
            ? contactInfo.nickname
            : existing.nickname,
        avatar: (contactInfo.avatar?.isNotEmpty ?? false)
            ? contactInfo.avatar
            : existing.avatar,
        abstract: (contactInfo.abstract?.isNotEmpty ?? false)
            ? contactInfo.abstract
            : existing.abstract,
        email: (contactInfo.email?.isNotEmpty ?? false)
            ? contactInfo.email
            : existing.email,
        phone: (contactInfo.phone?.isNotEmpty ?? false)
            ? contactInfo.phone
            : existing.phone,
        gender: contactInfo.gender != 0 ? contactInfo.gender : existing.gender,
      );

      if (merged != existing || force) {
        final nextMap = Map<String, UserInfo>.from(state.userMap);
        nextMap[userId] = merged;
        emit(state.copyWith(userMap: nextMap, version: state.version + 1));
      }
      return;
    }

    final nextMap = Map<String, UserInfo>.from(state.userMap);
    nextMap[userId] = contactInfo;
    emit(state.copyWith(userMap: nextMap, version: state.version + 1));
  }

  Future<void> updateContactsByIds(List<String> userIds) async {
    if (userIds.isEmpty) return;
    _logger.info({'text': '按ID批量刷新联系人', 'data': {'count': userIds.length}});
    final users = await _userBusiness.getUsersBasicInfo(userIds);
    if (users.isEmpty) return;

    final nextMap = Map<String, UserInfo>.from(state.userMap);
    var changed = false;
    for (final user in users) {
      final existing = nextMap[user.userId];
      if (existing != user) {
        nextMap[user.userId] = user;
        changed = true;
      }
    }

    if (changed) {
      emit(state.copyWith(userMap: nextMap, version: state.version + 1));
    }
  }

  UserInfo? getContact(String userId) {
    return state.userMap[userId];
  }
}
