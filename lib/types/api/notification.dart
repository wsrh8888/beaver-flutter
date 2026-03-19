class IGetNotificationEventsByIdsReq {
  final List<String> eventIds;
  IGetNotificationEventsByIdsReq({required this.eventIds});
  Map<String, dynamic> toJson() => {'eventIds': eventIds};
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

  factory NotificationEvent.fromJson(Map<String, dynamic> json) => NotificationEvent(
    eventId: json['eventId'] ?? '',
    type: json['type'] ?? 0,
    content: json['content'] ?? '',
    senderId: json['senderId'],
    receiverId: json['receiverId'],
    relatedId: json['relatedId'],
    status: json['status'] ?? 0,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? 0,
    updatedAt: json['updatedAt'],
  );
}

class IGetNotificationEventsByIdsRes {
  final List<NotificationEvent> events;
  IGetNotificationEventsByIdsRes({required this.events});
}

class IGetNotificationInboxByIdsReq {
  final List<String> inboxIds;
  IGetNotificationInboxByIdsReq({required this.inboxIds});
  Map<String, dynamic> toJson() => {'inboxIds': inboxIds};
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

  factory NotificationInbox.fromJson(Map<String, dynamic> json) => NotificationInbox(
    inboxId: json['inboxId'] ?? '',
    userId: json['userId'] ?? '',
    eventId: json['eventId'] ?? '',
    readStatus: json['readStatus'] ?? 0,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? 0,
    updatedAt: json['updatedAt'],
  );
}

class IGetNotificationInboxByIdsRes {
  final List<NotificationInbox> inboxes;
  IGetNotificationInboxByIdsRes({required this.inboxes});
}

class IGetNotificationReadCursorsReq {
  final List<int> categories;
  IGetNotificationReadCursorsReq({required this.categories});
  Map<String, dynamic> toJson() => {'categories': categories};
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

  factory NotificationReadCursor.fromJson(Map<String, dynamic> json) => NotificationReadCursor(
    category: json['category'] ?? 0,
    userId: json['userId'] ?? '',
    lastReadVersion: json['lastReadVersion'] ?? 0,
    version: json['version'] ?? 0,
    updatedAt: json['updatedAt'] ?? 0,
  );
}

class IGetNotificationReadCursorsRes {
  final List<NotificationReadCursor> cursors;
  IGetNotificationReadCursorsRes({required this.cursors});
}
