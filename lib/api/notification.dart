import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/notification.dart';
import 'package:beaver/common/config/env.dart';

/// 按ID拉取通知事件明细
Future<BaseResponse<IGetNotificationEventsByIdsRes>> getNotificationEventsByIdsApi(IGetNotificationEventsByIdsReq data) async {
  return httpClient.post<IGetNotificationEventsByIdsRes>(
    '$baseUrl/api/notification/v1/getEventsByIds',
    data: data.toJson(),
    fromJsonT: (json) => IGetNotificationEventsByIdsRes(
      events: (json['events'] as List).map((e) => NotificationEvent.fromJson(e)).toList(),
    ),
  );
}

/// 按ID拉取通知收件箱明细
Future<BaseResponse<IGetNotificationInboxByIdsRes>> getNotificationInboxByIdsApi(IGetNotificationInboxByIdsReq data) async {
  return httpClient.post<IGetNotificationInboxByIdsRes>(
    '$baseUrl/api/notification/v1/getInboxByIds',
    data: data.toJson(),
    fromJsonT: (json) => IGetNotificationInboxByIdsRes(
      inboxes: (json['inboxes'] as List).map((e) => NotificationInbox.fromJson(e)).toList(),
    ),
  );
}

/// 按分类拉取通知已读游标
Future<BaseResponse<IGetNotificationReadCursorsRes>> getNotificationReadCursorsApi(IGetNotificationReadCursorsReq data) async {
  return httpClient.post<IGetNotificationReadCursorsRes>(
    '$baseUrl/api/notification/v1/getReadCursors',
    data: data.toJson(),
    fromJsonT: (json) => IGetNotificationReadCursorsRes(
      cursors: (json['cursors'] as List).map((e) => NotificationReadCursor.fromJson(e)).toList(),
    ),
  );
}
