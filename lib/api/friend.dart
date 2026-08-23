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
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/common/config/env.dart';

/// 批量获取好友数据
Future<BaseResponse<IGetFriendsListByIdsRes>> getFriendsListByIdsApi(
  IGetFriendsListByIdsReq data,
) {
  final url = '$baseUrl/api/friend/v1/getFriendsListByIds';
  return httpClient.post<IGetFriendsListByIdsRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetFriendsListByIdsRes.fromJson(json),
  );
}

/// 批量获取好友验证数据
Future<BaseResponse<IGetFriendVerifiesListByIdsRes>>
getFriendVerifiesListByIdsApi(IGetFriendVerifiesListByIdsReq data) {
  final url = '$baseUrl/api/friend/v1/getFriendVerifiesListByIds';
  return httpClient.post<IGetFriendVerifiesListByIdsRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetFriendVerifiesListByIdsRes.fromJson(json),
  );
}

/// 搜索用户 (对标 Desktop getSearchFriendApi)
Future<BaseResponse<IResSearchUserInfo>> getSearchFriendApi(
  ISearchUserReq data,
) {
  final url = '$baseUrl/api/friend/v1/search';
  return httpClient.get<IResSearchUserInfo>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IResSearchUserInfo.fromJson(json),
  );
}

/// 申请添加好友 (对标 Desktop applyAddFriendApi)
Future<BaseResponse<void>> applyAddFriendApi(IAddFriendReq data) {
  final url = '$baseUrl/api/friend/v1/add_friend';
  return httpClient.post<void>(url, data: data.toJson());
}

/// 验证好友申请 (对标 Desktop valiFrienddAPi)
Future<BaseResponse<void>> valiFriendApi(IValiFriendReq data) {
  final url = '$baseUrl/api/friend/v1/valid';
  return httpClient.post<void>(url, data: data.toJson());
}

/// 修改好友备注 (对标 Desktop updateRemarkNameApi)
Future<BaseResponse<INoticeUpdateRes>> updateRemarkNameApi(
  INoticeUpdateReq data,
) {
  final url = '$baseUrl/api/friend/v1/update_notice';
  return httpClient.post<INoticeUpdateRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => INoticeUpdateRes.fromJson(json),
  );
}

