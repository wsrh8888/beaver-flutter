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
import 'package:beaver/types/api/notification.dart';
import 'package:beaver/common/config/env.dart';

/// 按ID拉取通知事件明细
Future<BaseResponse<IGetNotificationEventsByIdsRes>> getNotificationEventsByIdsApi(
  IGetNotificationEventsByIdsReq data,
) {
  return httpClient.post<IGetNotificationEventsByIdsRes>(
    '$baseUrl/api/notification/v1/getEventsByIds',
    data: data.toJson(),
    fromJsonT: (json) => IGetNotificationEventsByIdsRes(
      events: (json['events'] as List?)
              ?.map((e) => INotificationEventItem.fromJson(e))
              .toList() ??
          [],
    ),
  );
}

/// 按ID拉取通知收件箱明细
Future<BaseResponse<IGetNotificationInboxByIdsRes>> getNotificationInboxByIdsApi(
  IGetNotificationInboxByIdsReq data,
) {
  return httpClient.post<IGetNotificationInboxByIdsRes>(
    '$baseUrl/api/notification/v1/getInboxByIds',
    data: data.toJson(),
    fromJsonT: (json) => IGetNotificationInboxByIdsRes(
      inbox: (json['inbox'] as List?)
              ?.map((e) => INotificationInboxItem.fromJson(e))
              .toList() ??
          [],
    ),
  );
}

/// 按分类拉取通知已读游标
Future<BaseResponse<IGetNotificationReadCursorsRes>> getNotificationReadCursorsApi(
  IGetNotificationReadCursorsReq data,
) {
  return httpClient.post<IGetNotificationReadCursorsRes>(
    '$baseUrl/api/notification/v1/getReadCursors',
    data: data.toJson(),
    fromJsonT: (json) => IGetNotificationReadCursorsRes(
      cursors: (json['cursors'] as List?)
              ?.map((e) => INotificationReadCursorItem.fromJson(e))
              .toList() ??
          [],
    ),
  );
}

/// 按分类标记所有通知为已读
Future<BaseResponse<IMarkReadByCategoryRes>> markReadByCategoryApi(
  IMarkReadByCategoryReq data,
) {
  return httpClient.post<IMarkReadByCategoryRes>(
    '$baseUrl/api/notification/v1/markReadByCategory',
    data: data.toJson(),
    fromJsonT: (json) => IMarkReadByCategoryRes.fromJson(json),
  );
}
