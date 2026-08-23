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

class IReportVersionReq {
  final String? userId;
  final String deviceId;
  final String version;
  final String appId;
  final int platformId;
  final int archId;

  IReportVersionReq({
    this.userId,
    required this.deviceId,
    required this.version,
    required this.appId,
    required this.platformId,
    required this.archId,
  });

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'platformId': platformId,
      'archId': archId,
    };
  }

  Map<String, String> toHeaders() {
    final headers = {
      'deviceId': deviceId,
      'version': version,
    };
    if (userId != null && userId!.isNotEmpty) {
      headers['Beaver-User-Id'] = userId!;
    }
    return headers;
  }
}

class IGetLatestVersionReq {
  final String? userId;
  final String deviceId;
  final String version;
  final String appId;
  final int platformId;
  final int archId;

  IGetLatestVersionReq({
    this.userId,
    required this.deviceId,
    required this.version,
    required this.appId,
    required this.platformId,
    required this.archId,
  });

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'platformId': platformId,
      'archId': archId,
    };
  }

  Map<String, String> toHeaders() {
    final headers = {
      'deviceId': deviceId,
      'version': version,
    };
    if (userId != null && userId!.isNotEmpty) {
      headers['Beaver-User-Id'] = userId!;
    }
    return headers;
  }
}

class IGetLatestVersionRes {
  final bool hasUpdate;
  final bool forceUpdate;
  final int? architectureId;
  final String? version;
  final String fileUrl;
  final int size;
  final String md5;
  final String? description;
  final String? releaseNotes;

  IGetLatestVersionRes({
    required this.hasUpdate,
    this.forceUpdate = false,
    this.architectureId,
    this.version,
    required this.fileUrl,
    required this.size,
    required this.md5,
    this.description,
    this.releaseNotes,
  });

  factory IGetLatestVersionRes.fromJson(Map<String, dynamic> json) {
    return IGetLatestVersionRes(
      hasUpdate: json['hasUpdate'] ?? false,
      forceUpdate: json['forceUpdate'] ?? false,
      architectureId: json['architectureId'],
      version: json['version'],
      fileUrl: json['fileUrl']?.toString() ?? '',
      size: json['size'] ?? 0,
      md5: json['md5'] ?? '',
      description: json['description'],
      releaseNotes: json['releaseNotes'],
    );
  }
}
