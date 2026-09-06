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

import 'package:beaver/features/setting/privacy_page/data/models/privacy.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('repo-setting-privacy_page');

class PrivacyRepository {
  Future<PrivacyPolicy> getPrivacyPolicy() async {
    try {

    // 模拟获取隐私政策
    await Future.delayed(const Duration(seconds: 1));
    return const PrivacyPolicy(
      title: 'Beaver隐私政策',
      updateTime: '2025年4月3日',
      content: 'Beaver重视您的隐私。本隐私政策说明了我们如何收集、使用、披露、处理和保护您在使用我们的服务时所提供的信息。请您仔细阅读本政策，了解我们的隐私惯例。',
    );
    } catch (e, st) {
      _logger.warn({'text':'PrivacyRepository.getPrivacyPolicy 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}