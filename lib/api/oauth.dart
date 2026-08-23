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

import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/oauth.dart';

/// 查询扫码会话（公开）
Future<BaseResponse<IGetQrCodeSceneRes>> getQrCodeSceneApi(String sceneId) {
  final url = '$baseUrl/api/open/oauth_public/v1/qrcode_scene';
  return httpClient.get<IGetQrCodeSceneRes>(
    url,
    queryParameters: {'sceneId': sceneId},
    fromJsonT: (json) => IGetQrCodeSceneRes.fromJson(json as Map<String, dynamic>),
  );
}

/// 标记已扫码（需 IM 登录态）
Future<BaseResponse<IScanQrCodeRes>> scanQrCodeApi(IScanQrCodeReq data) {
  final url = '$baseUrl/api/open/oauth/v1/qrcode_scan';
  return httpClient.post<IScanQrCodeRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IScanQrCodeRes.fromJson(json as Map<String, dynamic>),
  );
}

/// 确认扫码授权（需 IM 登录态）
Future<BaseResponse<IConfirmQrCodeRes>> confirmQrCodeApi(IConfirmQrCodeReq data) {
  final url = '$baseUrl/api/open/oauth/v1/qrcode_confirm';
  return httpClient.post<IConfirmQrCodeRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IConfirmQrCodeRes.fromJson(json as Map<String, dynamic>),
  );
}

/// 取消扫码授权（需 IM 登录态）
Future<BaseResponse<ICancelQrCodeRes>> cancelQrCodeApi(ICancelQrCodeReq data) {
  final url = '$baseUrl/api/open/oauth/v1/qrcode_cancel';
  return httpClient.post<ICancelQrCodeRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICancelQrCodeRes.fromJson(json as Map<String, dynamic>),
  );
}
