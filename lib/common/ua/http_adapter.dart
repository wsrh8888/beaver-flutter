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
import 'package:beaver/common/config/config.dart';

/**
 * UA 模块第二层：适配层 (HttpAdapter)
 * 职责：接管系统级 HttpClient，实现 User-Agent 的全局静默注入。
 */
class BeaverUaHttpAdapter extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // 强制挂载 UA 模块生成的标识符
    return super.createHttpClient(context)
      ..userAgent = AppConfig.userAgent;
  }
}
