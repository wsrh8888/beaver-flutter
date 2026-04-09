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
  
  // 群组模块
  static const String groupList = '/group/list';
  static const String groupCreate = '/group/create';
  static const String groupConfig = '/group/config';
  static const String groupMember = '/group/member';
  
  // 通话模块
  static const String callsPage = '/calls';
  static const String call = '/call';
  static const String callIncoming = '/call/incoming';
  
  // 发现模块
  static const String discoverMain = '/discover';
  
  // 设置模块
  static const String settingMain = '/setting';
  static const String settingTheme = '/setting/theme';
  static const String settingAbout = '/setting/about';
  static const String settingFeedback = '/setting/feedback';
  static const String settingPrivacy = '/setting/privacy';
  static const String settingAgreement = '/setting/agreement';
  static const String settingDisclaimer = '/setting/disclaimer';
  static const String settingUpdate = '/setting/update';
  
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
}
