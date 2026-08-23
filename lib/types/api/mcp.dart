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

class IRegisterToolReq {
  final String clientId;
  final String toolId;
  final String name;
  final String description;
  final String version;
  final Map<String, dynamic> metadata;

  IRegisterToolReq({
    required this.clientId,
    required this.toolId,
    required this.name,
    required this.description,
    required this.version,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'clientId': clientId,
    'toolId': toolId,
    'name': name,
    'description': description,
    'version': version,
    'metadata': metadata,
  };
}

class IRegisterToolResult {
  final bool success;
  final String? message;

  IRegisterToolResult({
    required this.success,
    this.message,
  });

  factory IRegisterToolResult.fromJson(Map<String, dynamic> json) => IRegisterToolResult(
    success: json['success'] ?? false,
    message: json['message'],
  );
}

class IGetClientToolsReq {
  final String clientId;
  IGetClientToolsReq({required this.clientId});
  Map<String, dynamic> toJson() => {'clientId': clientId};
}

class ToolInfo {
  final String toolId;
  final String name;
  final String description;
  final String version;
  final Map<String, dynamic> metadata;

  ToolInfo({
    required this.toolId,
    required this.name,
    required this.description,
    required this.version,
    required this.metadata,
  });

  factory ToolInfo.fromJson(Map<String, dynamic> json) => ToolInfo(
    toolId: json['toolId'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    version: json['version'] ?? '',
    metadata: json['metadata'] ?? {},
  );
}

class IGetClientToolsRes {
  final List<ToolInfo> tools;
  IGetClientToolsRes({required this.tools});
}
