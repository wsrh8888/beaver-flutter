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

import 'datasync.dart';

/// 用户同步请求
class IUserSyncReq {
  final List<IUserVersionItem> userVersions;

  IUserSyncReq({required this.userVersions});

  Map<String, dynamic> toJson() => {
    'userVersions': userVersions.map((e) => {'userId': e.userId, 'version': e.version}).toList(),
  };
}

/// 用户同步项
class IUserSyncItem {
  final String userId;
  final String nickName;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? abstract;
  final int gender;
  final int userType;
  final int status;
  final int version;
  final int? createdAt;
  final int? updatedAt;

  IUserSyncItem({
    required this.userId,
    required this.nickName,
    this.email,
    this.phone,
    this.avatar,
    this.abstract,
    required this.gender,
    required this.userType,
    required this.status,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory IUserSyncItem.fromJson(Map<String, dynamic> json) => IUserSyncItem(
    userId: json['userId'] ?? '',
    nickName: json['nickName'] ?? '',
    email: json['email'],
    phone: json['phone'],
    avatar: json['avatar'],
    abstract: json['abstract'],
    gender: json['gender'] ?? 3,
    userType: json['userType'] ?? 1,
    status: json['status'] ?? 1,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}

/// 用户同步响应
class IUserSyncRes {
  final List<IUserSyncItem> users;

  IUserSyncRes({required this.users});

  factory IUserSyncRes.fromJson(Map<String, dynamic> json) => IUserSyncRes(
    users: (json['users'] as List?)?.map((e) => IUserSyncItem.fromJson(e)).toList() ?? [],
  );
}

/// 更新用户信息请求
class IUpdateInfoReq {
  final String? nickName;
  final String? avatar;
  final String? abstract;
  final int? gender;

  IUpdateInfoReq({
    this.nickName,
    this.avatar,
    this.abstract,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('nickName', nickName);
    writeNotNull('avatar', avatar);
    writeNotNull('abstract', abstract);
    writeNotNull('gender', gender);
    return val;
  }
}

/// 更新邮箱请求
class IUpdateEmailReq {
  final String email;
  final String code;

  IUpdateEmailReq({required this.email, required this.code});

  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
  };
}

/// 用户基础信息响应
class IUserInfoRes {
  final String userId;
  final String nickName;
  final String avatar;
  final String abstract;
  final String? phone;
  final String? email;
  final int gender;
  final int version;

  IUserInfoRes({
    required this.userId,
    required this.nickName,
    required this.avatar,
    required this.abstract,
    this.phone,
    this.email,
    required this.gender,
    required this.version,
  });

  factory IUserInfoRes.fromJson(Map<String, dynamic> json) => IUserInfoRes(
    userId: json['userId'] ?? '',
    nickName: json['nickName'] ?? '',
    avatar: json['avatar'] ?? '',
    abstract: json['abstract'] ?? '',
    phone: json['phone'],
    email: json['email'],
    gender: json['gender'] ?? 0,
    version: json['version'] ?? 0,
  );
}
