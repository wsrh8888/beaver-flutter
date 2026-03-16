import 'package:beaver/features/setting/main/data/models/setting_item.dart';

class SettingRepository {
  Future<List<SettingItem>> getSettingItems() async {
    // 模拟获取设置�?
    await Future.delayed(const Duration(seconds: 1));
    return [
      SettingItem(id: 1, title: '账号与安�?, route: '/account-security'),
      SettingItem(id: 5, title: '主题设置', route: '/theme'),
      SettingItem(id: 2, title: '隐私政策', route: '/privacy'),
      SettingItem(id: 3, title: '用户协议', route: '/agreement'),
      SettingItem(id: 4, title: '检查更�?, route: '/update'),
    ];
  }
}

