import 'package:beaver/features/setting/main/data/models/setting_item.dart';

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
