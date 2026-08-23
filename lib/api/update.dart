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
import 'package:beaver/types/api/update.dart';
import 'package:beaver/common/config/env.dart';

/// 上报版本信息
Future<BaseResponse<void>> reportVersionApi(IReportVersionReq data) async {
  return httpClient.post<void>(
    '$baseUrl/api/platform/update_public/v1/report',
    data: data.toJson(),
    headers: data.toHeaders(),
    fromJsonT: (json) => null,
  );
}

/// 获取最新版本
Future<BaseResponse<IGetLatestVersionRes>> getLatestVersionApi(
  IGetLatestVersionReq data,
) async {
  return httpClient.post<IGetLatestVersionRes>(
    '$baseUrl/api/platform/update_public/v1/latest',
    data: data.toJson(),
    headers: data.toHeaders(),
    fromJsonT: (json) => IGetLatestVersionRes.fromJson(json),
  );
}
