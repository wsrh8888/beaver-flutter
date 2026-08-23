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
import 'package:beaver/types/api/moment.dart';
import 'package:beaver/common/config/env.dart';

/// 创建朋友圈
Future<BaseResponse<ICreateMomentRes>> createMomentApi(ICreateMomentReq data) {
  final url = '$baseUrl/api/moment/v1/create';
  return httpClient.post<ICreateMomentRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICreateMomentRes.fromJson(json),
  );
}

/// 获取朋友圈列表
Future<BaseResponse<IGetMomentListRes>> getMomentListApi(IGetMomentListReq data) {
  final url = '$baseUrl/api/moment/v1/list';
  return httpClient.post<IGetMomentListRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetMomentListRes.fromJson(json),
  );
}

/// 点赞朋友圈
Future<BaseResponse<ILikeMomentRes>> likeMomentApi(ILikeMomentReq data) {
  final url = '$baseUrl/api/moment/v1/like';
  return httpClient.post<ILikeMomentRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ILikeMomentRes.fromJson(json),
  );
}

/// 发表评论
Future<BaseResponse<ICreateMomentCommentRes>> createMomentCommentApi(ICreateMomentCommentReq data) {
  final url = '$baseUrl/api/moment/v1/comment/create';
  return httpClient.post<ICreateMomentCommentRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICreateMomentCommentRes.fromJson(json),
  );
}

/// 获取动态详情
Future<BaseResponse<IGetMomentDetailRes>> getMomentDetailApi(IGetMomentDetailReq data) {
  final url = '$baseUrl/api/moment/v1/detail';
  return httpClient.post<IGetMomentDetailRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetMomentDetailRes.fromJson(json),
  );
}

/// 删除朋友圈
Future<BaseResponse<void>> deleteMomentApi(IDeleteMomentReq data) {
  final url = '$baseUrl/api/moment/v1/delete';
  return httpClient.get<void>(
    url,
    queryParameters: data.toJson(),
  );
}

/// 获取动态评论列表
Future<BaseResponse<IGetMomentCommentsRes>> getMomentCommentsApi(IGetMomentCommentsReq data) {
  final url = '$baseUrl/api/moment/v1/comments';
  return httpClient.post<IGetMomentCommentsRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetMomentCommentsRes.fromJson(json),
  );
}

/// 获取动态点赞列表
Future<BaseResponse<IGetMomentLikesRes>> getMomentLikesApi(IGetMomentLikesReq data) {
  final url = '$baseUrl/api/moment/v1/likes';
  return httpClient.post<IGetMomentLikesRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetMomentLikesRes.fromJson(json),
  );
}

