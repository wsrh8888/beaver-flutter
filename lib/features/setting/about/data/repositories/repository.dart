import 'package:beaver/features/setting/about/data/models/app_info.dart';

class AboutRepository {
  Future<AppInfo> getAppInfo() async {
    // 模拟获取应用信息
    await Future.delayed(const Duration(seconds: 1));
    return const AppInfo(
      name: 'Beaver',
      version: '1.0.0',
      developer: 'Beaver Team',
      description: 'Beaver是一款致力于帮助用户拓展社交圈，发现志同道合朋友的即时通讯应用。我们相信真实的人际连接比以往任何时候都更加珍贵�?,
    );
  }
}

