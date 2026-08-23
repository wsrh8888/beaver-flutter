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
import 'package:beaver/types/api/emoji.dart';
import 'package:beaver/common/config/env.dart';

// 获取表情列表（通过ID列表）
Future<BaseResponse<dynamic>> getEmojisByIdsApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post('$baseUrl/api/emoji/v1/getEmojisByUuids', data: data);
}

// 获取表情收藏列表（通过ID列表）
Future<BaseResponse<EmojiCollectsResponse>> getEmojiCollectsByIdsApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post<EmojiCollectsResponse>(
    '$baseUrl/api/emoji/v1/collects-by-ids',
    data: data,
    fromJsonT: (json) => EmojiCollectsResponse(
      collects: (json['collects'] as List)
          .map((e) => EmojiCollectItem.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包收藏列表（通过ID列表）
Future<BaseResponse<EmojiPackageCollectsResponse>>
getEmojiPackageCollectsByIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackageCollectsResponse>(
    '$baseUrl/api/emoji/v1/package-collects-by-ids',
    data: data,
    fromJsonT: (json) => EmojiPackageCollectsResponse(
      collects: (json['collects'] as List)
          .map((e) => EmojiPackageItem.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包列表（通过ID列表）
Future<BaseResponse<EmojiPackagesResponse>> getEmojiPackagesByIdsApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post<EmojiPackagesResponse>(
    '$baseUrl/api/emoji/v1/packages-by-ids',
    data: data,
    fromJsonT: (json) => EmojiPackagesResponse(
      packages: (json['packages'] as List)
          .map((e) => EmojiPackage.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包内容列表（通过表情包ID列表）
Future<BaseResponse<EmojiPackageContentsResponse>>
getEmojiPackageContentsByPackageIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackageContentsResponse>(
    '$baseUrl/api/emoji/v1/package-contents-by-package-ids',
    data: data,
    fromJsonT: (json) => EmojiPackageContentsResponse(
      contents: (json['contents'] as List)
          .map((e) => EmojiPackageContent.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包内容列表（通过关联ID列表）
Future<BaseResponse<EmojiPackageContentsResponse>>
getEmojiPackageContentsByRelationIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackageContentsResponse>(
    '$baseUrl/api/emoji/v1/package-contents-by-relation-ids',
    data: data,
    fromJsonT: (json) => EmojiPackageContentsResponse(
      contents: (json['contents'] as List)
          .map((e) => EmojiPackageContent.fromJson(e))
          .toList(),
    ),
  );
}
// 获取表情包列表（商店列表）
Future<BaseResponse<EmojiShopPackagesResponse>> getEmojiPackagesApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post<EmojiShopPackagesResponse>(
    '$baseUrl/api/emoji/v1/packageList',
    data: data,
    fromJsonT: (json) => EmojiShopPackagesResponse(
      count: json['count'] ?? 0,
      list: (json['list'] as List)
          .map((e) => EmojiShopPackageItem.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包详情
Future<BaseResponse<EmojiPackageDetailResponse>> getEmojiPackageDetailApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post<EmojiPackageDetailResponse>(
    '$baseUrl/api/emoji/v1/packageInfo',
    data: data,
    fromJsonT: (json) => EmojiPackageDetailResponse.fromJson(json),
  );
}

// 更新表情包收藏状态（订阅/取消订阅）
Future<BaseResponse<dynamic>> updateFavoriteEmojiPackageApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post('$baseUrl/api/emoji/v1/packageFavorite', data: data);
}

// 添加表情并自动收藏
Future<BaseResponse<dynamic>> addEmojiApi(Map<String, dynamic> data) async {
  return httpClient.post('$baseUrl/api/emoji/v1/add', data: data);
}
