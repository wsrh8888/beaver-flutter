import 'package:beaver/features/setting/update/data/models/update.dart';

class UpdateRepository {
  Future<UpdateInfo> checkUpdate(String currentVersion) async {
    // 模拟检查更�?
    await Future.delayed(const Duration(seconds: 2));
    
    return UpdateInfo(
      hasUpdate: false,
      latestVersion: null,
      isChecking: false,
      isDownloading: false,
      downloadProgress: 0,
      lastCheckTime: DateTime.now(),
    );
  }

  Future<bool> downloadUpdate(String downloadUrl) async {
    // 模拟下载更新
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }
}

