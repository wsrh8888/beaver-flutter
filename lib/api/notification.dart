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
