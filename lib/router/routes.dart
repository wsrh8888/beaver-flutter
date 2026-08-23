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

import 'package:flutter/material.dart';

class AppRoutes {
  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // 聊天模块
  static const String chatList = '/chat/list';
  static const String chatDetail = '/chat/detail';
  static const String privateChatSetting = '/chat/setting/private';
  static const String groupChatSetting = '/chat/setting/group';
  static const String chatForward = '/chat/forward';
  static const String chatForwardDetail = '/chat/forward/detail';
  static const String chatShareConversation = '/chat/share';
  /// 与 chatShareConversation 同页，推荐新代码使用此路由
  static const String selectConversation = '/common/select_conversation';
  static const String selectFriend = '/common/select_friend';
  
  // 联系人模块
  static const String contactList = '/contact/list';
  static const String contactDetail = '/contact/detail/:userId';
  static const String addContact = '/contact/add';
  static const String searchContact = '/contact/search';
  static const String newFriends = '/contact/new-friends';
  static const String groupNotifications = '/group/notifications';
  
  // 动态模块
  static const String momentList = '/moment/list';
  static const String momentDetail = '/moment/detail';
  static const String momentPost = '/moment/post';
  static const String momentMessages = '/moment/messages';
  
  // 群组模块
  static const String groupList = '/group/list';
  static const String groupCreate = '/group/create';
  static const String groupConfig = '/group/config';
  static const String groupMember = '/group/member';
  static const String groupJoin = '/group/join';
  
  // 通话模块
  static const String callsPage = '/calls';
  static const String call = '/call';
  static const String callIncoming = '/call/incoming';
  
  // 发现模块
  static const String discoverMain = '/discover';

  // 工作台模块
  static const String workbenchHome = '/workbench';

  // 圈子模块
  static const String circleList = '/circle/list';
  static const String circleFeed = '/circle/feed';
  static const String circlePost = '/circle/post';
  static const String circleDetail = '/circle/detail';
  static const String circleJoin = '/circle/join';
  static const String circleSetting = '/circle/setting';
  
  // 设置模块
  static const String settingMain = '/setting';
  static const String settingAccountSecurity = '/setting/account-security';
  static const String settingChangePassword = '/setting/change-password';
  static const String settingDevices = '/setting/devices';
  static const String settingTheme = '/setting/theme';
  static const String settingAbout = '/setting/about';
  static const String settingFeedback = '/setting/feedback';
  static const String settingPrivacy = '/setting/privacy';
  static const String settingAgreement = '/setting/agreement';
  static const String settingDisclaimer = '/setting/disclaimer';
  static const String settingUpdate = '/setting/update';
  static const String settingOpenSource = '/setting/open-source';
  
  // 引导模块
  static const String guideMain = '/guide';
  
  // 用户模块
  static const String profile = '/user/profile';
  static const String mine = '/user/mine';
  static const String qrcode = '/user/qrcode';
  static const String userConfig = '/user/config';

  // 表情模块
  static const String emojiShop = '/emoji/shop';
  static const String emojiDetail = '/emoji/detail';

  // 通用模块
  static const String webview = '/common/webview';
  static const String scan = '/common/scan';
  static const String entityShare = '/common/share';
  static const String oauthScanConfirm = '/oauth/scan-confirm';
}
