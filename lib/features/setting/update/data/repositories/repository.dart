import 'package:beaver/features/setting/update/data/models/update.dart';

class UpdateRepository {
  Future<UpdateInfo?> checkUpdate(String currentVersion) async {
    // 模拟检查更新
    await Future.delayed(const Duration(seconds: 1));
    return const UpdateInfo(
      hasUpdate: true,
      latestVersion: VersionInfo(
        version: '1.1.0',
        size: '15MB',
        releaseNotes: '1. 修复了一些已知问题\n2. 优化了性能',
        downloadUrl: 'https://example.com/beaver-1.1.0.apk',
      ),
      isChecking: false,
      isDownloading: false,
      downloadProgress: 0,
    );
  }
}
