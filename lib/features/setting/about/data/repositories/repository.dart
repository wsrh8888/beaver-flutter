import 'package:beaver/features/setting/about/data/models/app_info.dart';

class AboutRepository {
  Future<AppInfo> getAppInfo() async {
    return const AppInfo(
      name: 'Beaver',
      version: '1.0.0',
      developer: 'Beaver Team',
      description: '专业、安全、高效的即时通讯软件',
    );
  }
}
