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

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:beaver/api/auth.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/common/request/request.dart';

class LoginRepository {
  Future<BaseResponse<EmailPasswordLoginRes>> login(
    String email,
    String password,
  ) async {
    final deviceId = await StorageUtil.getDeviceId();
    final req = EmailPasswordLoginReq(
      email: email,
      // 使用 MD5 加密密码
      password: md5.convert(utf8.encode(password)).toString(),
      deviceId: deviceId,
    );
    final response = await emailPasswordLoginApi(req);

    if (response.code == 0 && response.result != null) {
      await StorageUtil.setString('token', response.result!.token);
      await StorageUtil.setString('userId', response.result!.userId);
    }
    return response;
  }
}
