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

import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/mcp.dart';
import 'package:beaver/common/config/env.dart';

/// 注册工具到云端MCP服务器
Future<BaseResponse<List<IRegisterToolResult>>> registerToolApi(IRegisterToolReq data) async {
  return httpClient.post<List<IRegisterToolResult>>(
    '$baseUrl/api/mcp/v1/registerTool',
    data: data.toJson(),
    fromJsonT: (json) => (json as List).map((e) => IRegisterToolResult.fromJson(e)).toList(),
  );
}

/// 获取客户端工具列表
Future<BaseResponse<IGetClientToolsRes>> getClientToolsApi(IGetClientToolsReq data) async {
  return httpClient.post<IGetClientToolsRes>(
    '$baseUrl/api/mcp/v1/getClientTools',
    data: data.toJson(),
    fromJsonT: (json) => IGetClientToolsRes(
      tools: (json['tools'] as List).map((e) => ToolInfo.fromJson(e)).toList(),
    ),
  );
}
