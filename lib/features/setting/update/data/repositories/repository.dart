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
