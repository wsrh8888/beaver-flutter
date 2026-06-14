import 'package:beaver/api/update.dart';
import 'package:beaver/types/api/update.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/features/setting/update/data/models/update.dart';
import 'package:beaver/features/setting/update/data/platform_info.dart';

class UpdateRepository {
  Future<UpdateCheckResult> checkUpdate() async {
    final platform = UpdatePlatformInfo.current();
    if (platform.platformId == 0) {
      return const UpdateCheckResult.failure('当前平台不支持检查更新');
    }

    final response = await getLatestVersionApi(IGetLatestVersionReq(
      deviceId: AppConfig.deviceId,
      version: AppConfig.version,
      appId: AppConfig.updateAppId,
      platformId: platform.platformId,
      archId: platform.archId,
    ));

    if (response.code != 0) {
      return UpdateCheckResult.failure(
        response.msg.isNotEmpty ? response.msg : '检查更新失败',
      );
    }

    final result = response.result;
    if (result == null || !result.hasUpdate) {
      return UpdateCheckResult.success(
        UpdateInfo(
          hasUpdate: false,
          isChecking: false,
          isDownloading: false,
          downloadProgress: 0,
          lastCheckTime: DateTime.now(),
        ),
      );
    }

    if (result.fileUrl.isEmpty) {
      return const UpdateCheckResult.failure('服务端未返回下载地址');
    }

    return UpdateCheckResult.success(
      UpdateInfo(
        hasUpdate: true,
        latestVersion: VersionInfo(
          version: result.version ?? '',
          size: result.size > 0
              ? '${(result.size / 1024 / 1024).toStringAsFixed(1)}MB'
              : '--',
          releaseNotes: result.releaseNotes ?? '',
          downloadUrl: result.fileUrl,
          isForce: result.forceUpdate,
        ),
        isChecking: false,
        isDownloading: false,
        downloadProgress: 0,
        lastCheckTime: DateTime.now(),
      ),
    );
  }
}
