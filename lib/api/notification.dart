import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/http/http_client.dart';

// 类型定义
class IGetNotificationEventsByIdsReq {
  final List<String> eventIds;

  IGetNotificationEventsByIdsReq({required this.eventIds});
}

class NotificationEvent {
  final String eventId;
  final int type;
  final String content;
  final String? senderId;
  final String? receiverId;
  final String? relatedId;
  final int status;
  final int version;
  final int createdAt;
  final int? updatedAt;

  NotificationEvent({
    required this.eventId,
    required this.type,
    required this.content,
    this.senderId,
    this.receiverId,
    this.relatedId,
    required this.status,
    required this.version,
    required this.createdAt,
    this.updatedAt,
  });
}

class IGetNotificationEventsByIdsRes {
  final List<NotificationEvent> events;

  IGetNotificationEventsByIdsRes({required this.events});
}

class IGetNotificationInboxByIdsReq {
  final List<String> inboxIds;

  IGetNotificationInboxByIdsReq({required this.inboxIds});
}

class NotificationInbox {
  final String inboxId;
  final String userId;
  final String eventId;
  final int readStatus;
  final int version;
  final int createdAt;
  final int? updatedAt;

  NotificationInbox({
    required this.inboxId,
    required this.userId,
    required this.eventId,
    required this.readStatus,
    required this.version,
    required this.createdAt,
    this.updatedAt,
  });
}

class IGetNotificationInboxByIdsRes {
  final List<NotificationInbox> inboxes;

  IGetNotificationInboxByIdsRes({required this.inboxes});
}

class IGetNotificationReadCursorsReq {
  final List<int> categories;

  IGetNotificationReadCursorsReq({required this.categories});
}

class NotificationReadCursor {
  final int category;
  final String userId;
  final int lastReadVersion;
  final int version;
  final int updatedAt;

  NotificationReadCursor({
    required this.category,
    required this.userId,
    required this.lastReadVersion,
    required this.version,
    required this.updatedAt,
  });
}

class IGetNotificationReadCursorsRes {
  final List<NotificationReadCursor> cursors;

  IGetNotificationReadCursorsRes({required this.cursors});
}

/// 按ID拉取通知事件明细
Future<IGetNotificationEventsByIdsRes> getNotificationEventsByIdsApi(IGetNotificationEventsByIdsReq data) async {
  final response = await HttpClient.post(
    '${Env.baseUrl}/api/notification/getEventsByIds',
    data: {'eventIds': data.eventIds},
  );
  return IGetNotificationEventsByIdsRes(
    events: (response['events'] as List).map((e) => NotificationEvent(
          eventId: e['eventId'],
          type: e['type'],
          content: e['content'],
          senderId: e['senderId'],
          receiverId: e['receiverId'],
          relatedId: e['relatedId'],
          status: e['status'],
          version: e['version'],
          createdAt: e['createdAt'],
          updatedAt: e['updatedAt'],
        )).toList(),
  );
}

/// 按ID拉取通知收件箱明细
Future<IGetNotificationInboxByIdsRes> getNotificationInboxByIdsApi(IGetNotificationInboxByIdsReq data) async {
  final response = await HttpClient.post(
    '${Env.baseUrl}/api/notification/getInboxByIds',
    data: {'inboxIds': data.inboxIds},
  );
  return IGetNotificationInboxByIdsRes(
    inboxes: (response['inboxes'] as List).map((e) => NotificationInbox(
          inboxId: e['inboxId'],
          userId: e['userId'],
          eventId: e['eventId'],
          readStatus: e['readStatus'],
          version: e['version'],
          createdAt: e['createdAt'],
          updatedAt: e['updatedAt'],
        )).toList(),
  );
}

/// 按分类拉取通知已读游标
Future<IGetNotificationReadCursorsRes> getNotificationReadCursorsApi(IGetNotificationReadCursorsReq data) async {
  final response = await HttpClient.post(
    '${Env.baseUrl}/api/notification/getReadCursors',
    data: {'categories': data.categories},
  );
  return IGetNotificationReadCursorsRes(
    cursors: (response['cursors'] as List).map((e) => NotificationReadCursor(
          category: e['category'],
          userId: e['userId'],
          lastReadVersion: e['lastReadVersion'],
          version: e['version'],
          updatedAt: e['updatedAt'],
        )).toList(),
  );
}
