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

import 'package:beaver/features/setting/about/data/models/app_info.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('repo-setting-about');

class AboutRepository {
  Future<AppInfo> getAppInfo() async {
    try {

    return const AppInfo(
      name: 'Beaver',
      version: '1.0.0',
      developer: 'Beaver Team',
      description: '专业、安全、高效的即时通讯软件',
    );
    } catch (e, st) {
      _logger.warn({'text':'AboutRepository.getAppInfo 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
