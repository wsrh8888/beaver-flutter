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

import 'package:beaver/features/setting/main/data/models/setting_item.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('repo-setting-main');

class SettingMainRepository {
  List<SettingItem> getSettingItems() {
    return [
      const SettingItem(id: 1, title: '账号与安全', route: '/setting/account-security'),
      const SettingItem(id: 2, title: '新消息通知', route: '/notification'),
      const SettingItem(id: 3, title: '隐私', route: '/privacy'),
      const SettingItem(id: 4, title: '通用', route: '/common'),
      const SettingItem(id: 6, title: '关于Beaver', route: '/about'),
      const SettingItem(id: 7, title: '帮助与反馈', route: '/feedback'),
      const SettingItem(id: 8, title: '检查更新', route: '/update'),
    ];
  }
}
