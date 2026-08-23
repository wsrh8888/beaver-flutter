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

import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/user.dart';
import 'package:beaver/common/config/env.dart';

/// 用户数据同步
Future<BaseResponse<IUserSyncRes>> userSyncApi(IUserSyncReq data) {
  final url = '$baseUrl/api/user/v1/sync';
  return httpClient.post<IUserSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IUserSyncRes.fromJson(json));
}

/// 更新用户信息
Future<BaseResponse<UpdateInfoRes>> updateInfoApi(IUpdateInfoReq data) {
  final url = '$baseUrl/api/user/v1/update_info';
  return httpClient.post<UpdateInfoRes>(url, data: data.toJson(), fromJsonT: (json) => UpdateInfoRes());
}

/// 修改邮箱
Future<BaseResponse<UpdateEmailRes>> updateEmailApi(IUpdateEmailReq data) {
  final url = '$baseUrl/api/user/v1/update_email';
  return httpClient.post<UpdateEmailRes>(url, data: data.toJson(), fromJsonT: (json) => UpdateEmailRes());
}

/// 增加空的 Res 类用于对齐 api 定义
class UpdateInfoRes {}
class UpdateEmailRes {}
