class IGetNotificationEventsByIdsReq {
  final List<String> eventIds;

  IGetNotificationEventsByIdsReq({required this.eventIds});

  Map<String, dynamic> toJson() => {'eventIds': eventIds};
}

class INotificationEventItem {
  final String eventId;
  final String eventType;
  final String category;
  final int version;
  final String? fromUserId;
  final String? targetId;
  final String targetType;
  final String payload;
  final int priority;
  final int status;
  final String? dedupHash;
  final int createdAt;
  final int updatedAt;

  INotificationEventItem({
    required this.eventId,
    required this.eventType,
    required this.category,
    required this.version,
    this.fromUserId,
    this.targetId,
    required this.targetType,
    required this.payload,
    required this.priority,
    required this.status,
    this.dedupHash,
    required this.createdAt,
    required this.updatedAt,
  });

  factory INotificationEventItem.fromJson(Map<String, dynamic> json) =>
      INotificationEventItem(
        eventId: json['eventId'] ?? '',
        eventType: json['eventType'] ?? '',
        category: json['category'] ?? '',
        version: (json['version'] as num?)?.toInt() ?? 0,
        fromUserId: json['fromUserId'],
        targetId: json['targetId'],
        targetType: json['targetType'] ?? '',
        payload: json['payload'] ?? '',
        priority: (json['priority'] as num?)?.toInt() ?? 5,
        status: (json['status'] as num?)?.toInt() ?? 1,
        dedupHash: json['dedupHash'],
        createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
        updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
      );
}

class IGetNotificationEventsByIdsRes {
  final List<INotificationEventItem> events;

  IGetNotificationEventsByIdsRes({required this.events});
}

class IGetNotificationInboxByIdsReq {
  final List<String> eventIds;

  IGetNotificationInboxByIdsReq({required this.eventIds});

  Map<String, dynamic> toJson() => {'eventIds': eventIds};
}

class INotificationInboxItem {
  final String eventId;
  final String eventType;
  final String category;
  final int version;
  final bool isRead;
  final int readAt;
  final int status;
  final bool isDeleted;
  final bool silent;
  final int createdAt;
  final int updatedAt;

  INotificationInboxItem({
    required this.eventId,
    required this.eventType,
    required this.category,
    required this.version,
    required this.isRead,
    required this.readAt,
    required this.status,
    required this.isDeleted,
    required this.silent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory INotificationInboxItem.fromJson(Map<String, dynamic> json) =>
      INotificationInboxItem(
        eventId: json['eventId'] ?? '',
        eventType: json['eventType'] ?? '',
        category: json['category'] ?? '',
        version: (json['version'] as num?)?.toInt() ?? 0,
        isRead: json['isRead'] == true,
        readAt: (json['readAt'] as num?)?.toInt() ?? 0,
        status: (json['status'] as num?)?.toInt() ?? 1,
        isDeleted: json['isDeleted'] == true,
        silent: json['silent'] == true,
        createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
        updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
      );
}

class IGetNotificationInboxByIdsRes {
  final List<INotificationInboxItem> inbox;

  IGetNotificationInboxByIdsRes({required this.inbox});
}

class IGetNotificationReadCursorsReq {
  final List<String>? categories;

  IGetNotificationReadCursorsReq({this.categories});

  Map<String, dynamic> toJson() => {
    if (categories != null) 'categories': categories,
  };
}

class INotificationReadCursorItem {
  final String category;
  final int version;
  final int lastReadAt;

  INotificationReadCursorItem({
    required this.category,
    required this.version,
    required this.lastReadAt,
  });

  factory INotificationReadCursorItem.fromJson(Map<String, dynamic> json) =>
      INotificationReadCursorItem(
        category: json['category'] ?? '',
        version: (json['version'] as num?)?.toInt() ?? 0,
        lastReadAt: (json['lastReadAt'] as num?)?.toInt() ?? 0,
      );
}

class IGetNotificationReadCursorsRes {
  final List<INotificationReadCursorItem> cursors;

  IGetNotificationReadCursorsRes({required this.cursors});
}
