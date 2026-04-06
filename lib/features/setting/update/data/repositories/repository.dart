import 'dart:io';
import 'package:beaver/api/update.dart';
import 'package:beaver/api/file.dart'; // For previewOnlineFileApi
import 'package:beaver/types/api/update.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/features/setting/update/data/models/update.dart';

class UpdateRepository {
  Future<UpdateInfo?> checkUpdate(String currentVersion) async {
    // 1. 获取最新版本信息
    final response = await getLatestVersionApi(GetLatestVersionReq(
      userId: '', // 当前可为空或从 UserStore 取
      deviceId: AppConfig.deviceId,
      version: currentVersion,
      appId: 'beaver-flutter',
      platformId: Platform.isAndroid ? 4 : 3,
      archId: Platform.isAndroid ? 6 : 5,
    ));

    if (response.code == 0 && response.result != null && response.result!.hasUpdate) {
      final latest = response.result!;
      return UpdateInfo(
        hasUpdate: true,
        latestVersion: VersionInfo(
          version: latest.version ?? '',
          size: '${(latest.size / 1024 / 1024).toStringAsFixed(1)}MB',
          releaseNotes: latest.releaseNotes ?? '',
          downloadUrl: previewOnlineFileApi(latest.fileKey),
          isForce: false, // 服务端目前没有明确的 isForce 字段，默认为 false
        ),
        isChecking: false,
        isDownloading: false,
        downloadProgress: 0,
        lastCheckTime: DateTime.now(),
      );
    }
    return null;
  }
}
