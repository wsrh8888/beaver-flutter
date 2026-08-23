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

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:beaver/common/config/env.dart';
import 'package:beaver/shared/utils/storage_util.dart';

class HeaderConfig {
  static String? _deviceId;
  
  static Future<void> init() async {
    if (_deviceId != null) return;
    
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor;
    } else {
      _deviceId = 'flutter-unknown-device';
    }
  }

  static Map<String, dynamic> getCommonParams() {
    final token = StorageUtil.getString('token');
    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);
    
    return {
      'source': 'beaver-flutter',
      'timestamp': timestamp,
      'env': currentEnv.name,
      'deviceId': _deviceId ?? 'unknown',
      if (token != null && token.isNotEmpty) 'token': token,
    };
  }
}
