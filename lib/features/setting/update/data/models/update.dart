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

class VersionInfo {
  final String version;
  final String size;
  final String releaseNotes;
  final String downloadUrl;
  final bool isForce;

  const VersionInfo({
    required this.version,
    required this.size,
    required this.releaseNotes,
    required this.downloadUrl,
    this.isForce = false,
  });

  VersionInfo copyWith({
    String? version,
    String? size,
    String? releaseNotes,
    String? downloadUrl,
    bool? isForce,
  }) {
    return VersionInfo(
      version: version ?? this.version,
      size: size ?? this.size,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      isForce: isForce ?? this.isForce,
    );
  }
}

class UpdateInfo {
  final bool hasUpdate;
  final VersionInfo? latestVersion;
  final bool isChecking;
  final bool isDownloading;
  final int downloadProgress;
  final DateTime? lastCheckTime;

  const UpdateInfo({
    required this.hasUpdate,
    this.latestVersion,
    required this.isChecking,
    required this.isDownloading,
    required this.downloadProgress,
    this.lastCheckTime,
  });

  UpdateInfo copyWith({
    bool? hasUpdate,
    VersionInfo? latestVersion,
    bool? isChecking,
    bool? isDownloading,
    int? downloadProgress,
    DateTime? lastCheckTime,
  }) {
    return UpdateInfo(
      hasUpdate: hasUpdate ?? this.hasUpdate,
      latestVersion: latestVersion ?? this.latestVersion,
      isChecking: isChecking ?? this.isChecking,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      lastCheckTime: lastCheckTime ?? this.lastCheckTime,
    );
  }
}

class UpdateCheckResult {
  final UpdateInfo? updateInfo;
  final String? errorMessage;

  const UpdateCheckResult.success(UpdateInfo info)
      : updateInfo = info,
        errorMessage = null;

  const UpdateCheckResult.failure(this.errorMessage) : updateInfo = null;

  bool get isSuccess => errorMessage == null;
}
