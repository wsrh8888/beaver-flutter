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

import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/user.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-user-user');

class UserService extends BaseService {
  const UserService();

  /// 创建用户
  Future<void> create(UsersCompanion user) async {
    try {

    await db.into(db.users).insert(user);
    } catch (e, st) {
      _logger.warn({'text':'UserService.create 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 创建或更新用户（upsert操作）
  Future<void> upsert(UsersCompanion user) async {
    try {

    await db.into(db.users).insert(
          user,
          mode: InsertMode.insertOrReplace,
        );
    } catch (e, st) {
      _logger.warn({'text':'UserService.upsert 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量创建用户（调用upsert方法，避免重复数据错误）
  Future<void> batchCreate(List<IUserSyncItem> users) async {
    try {
    _logger.info({'text':'UserService.batchCreate 开始执行','data':{}});

    if (users.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final user in users) {
        batch.insert(
          db.users,
          UsersCompanion(
            userId: Value(user.userId),
            nickName: Value(user.nickName),
            email: Value(user.email),
            phone: Value(user.phone),
            avatar: Value(user.avatar),
            abstract: Value(user.abstract),
            gender: Value(user.gender),
            userType: Value(user.userType),
            status: Value(user.status),
            version: Value(user.version),
            createdAt: Value(user.createdAt),
            updatedAt: Value(user.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'UserService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据用户ID获取用户信息
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {

    final userData = await (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingleOrNull();
    
    if (userData == null) {
      return null;
    }

    return {
      'userInfo': {
        'userId': userData.userId,
        'nickName': userData.nickName,
        'avatar': userData.avatar ?? '',
        'abstract': userData.abstract ?? '',
        'phone': userData.phone,
        'email': userData.email,
        'gender': userData.gender ?? 0,
        'version': userData.version,
      }
    };
    } catch (e, st) {
      _logger.warn({'text':'UserService.getUserById 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据用户ID获取用户基本信息（包括版本号）
  Future<Map<String, dynamic>?> getUserBasicInfo(String userId) async {
    try {

    final userData = await (db.select(db.users)
          ..where((t) => t.userId.equals(userId))
          ..map((row) => {
                'userId': row.userId,
                'version': row.version,
              }))
        .getSingleOrNull();

    if (userData == null) {
      return null;
    }

    return {'userInfo': userData};
    } catch (e, st) {
      _logger.warn({'text':'UserService.getUserBasicInfo 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量获取用户基本信息（用于消息发送者信息）
  Future<List<Map<String, dynamic>>> getUsersBasicInfo(List<String> userIds) async {
    try {

    if (userIds.isEmpty) {
      return [];
    }

    final userData = await (db.select(db.users)..where((t) => t.userId.isIn(userIds))).get();

    return userData.map((user) => {
          'userId': user.userId,
          'nickName': user.nickName,
          'avatar': user.avatar ?? '',
          'userType': user.userType,
        }).toList();
    } catch (e, st) {
      _logger.warn({'text':'UserService.getUsersBasicInfo 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取所有用户基本信息（用于contactStore初始化）
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
    _logger.info({'text':'UserService.getAllUsers 开始执行','data':{}});

    final userData = await db.select(db.users).get();

    return userData.map((user) => {
          'userId': user.userId,
          'nickName': user.nickName,
          'avatar': user.avatar ?? '',
          'abstract': user.abstract ?? '',
          'phone': user.phone ?? '',
          'email': user.email ?? '',
          'gender': user.gender ?? 0,
          'userType': user.userType,
          'status': user.status ?? 0,
          'version': user.version ?? 0,
          'createdAt': user.createdAt ?? 0,
          'updatedAt': user.updatedAt ?? 0,
        }).toList();
    } catch (e, st) {
      _logger.warn({'text':'UserService.getAllUsers 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据 userId 获取用户
  Future<User?> getUserByUserId(String userId) async {
    try {

    return (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingleOrNull();
    } catch (e, st) {
      _logger.warn({'text':'UserService.getUserByUserId 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 更新用户信息
  Future<void> updateUser({
    required String userId,
    String? nickName,
    String? avatar,
    String? abstract,
    String? email,
    int? gender,
    int? version,
  }) async {
    try {

    await (db.update(db.users)..where((t) => t.userId.equals(userId))).write(
      UsersCompanion(
        nickName: nickName != null ? Value(nickName) : const Value.absent(),
        avatar: avatar != null ? Value(avatar) : const Value.absent(),
        abstract: abstract != null ? Value(abstract) : const Value.absent(),
        email: email != null ? Value(email) : const Value.absent(),
        gender: gender != null ? Value(gender) : const Value.absent(),
        version: version != null ? Value(version) : const Value.absent(),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    } catch (e, st) {
      _logger.warn({'text':'UserService.updateUser 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}