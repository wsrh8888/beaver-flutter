/// 数据类型
enum EDataType {
  users,
  friends,
  friendVerify,
  groups,
  groupMembers,
  groupJoinRequests,
  chatMessages,
  chatDatasync,
  chatConversationSettings,
  notificationEvents,
  notificationInboxes,
  notificationReads,
}

extension EDataTypeExtension on EDataType {
  String get value {
    switch (this) {
      case EDataType.users: return 'users';
      case EDataType.friends: return 'friends';
      case EDataType.friendVerify: return 'friend_verify';
      case EDataType.groups: return 'groups';
      case EDataType.groupMembers: return 'group_members';
      case EDataType.groupJoinRequests: return 'group_join_requests';
      case EDataType.chatMessages: return 'chat_messages';
      case EDataType.chatDatasync: return 'chat_datasync';
      case EDataType.chatConversationSettings: return 'chat_conversation_settings';
      case EDataType.notificationEvents: return 'notification_events';
      case EDataType.notificationInboxes: return 'notification_inboxes';
      case EDataType.notificationReads: return 'notification_reads';
    }
  }
}

/// 用户版本信息
class IUserVersionItem {
  final String userId;
  final int version;

  IUserVersionItem({required this.userId, required this.version});

  factory IUserVersionItem.fromJson(Map<String, dynamic> json) => IUserVersionItem(
    userId: json['userId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取所有用户同步信息请求
class IGetSyncAllUsersReq {
  final String? type;
  final int? since;

  IGetSyncAllUsersReq({this.type, this.since});

  Map<String, dynamic> toJson() => {
    if (type != null) 'type': type,
    if (since != null) 'since': since,
  };
}

/// 获取所有用户同步信息响应
class IGetSyncAllUsersRes {
  final List<IUserVersionItem> userVersions;
  final int serverTimestamp;

  IGetSyncAllUsersRes({required this.userVersions, required this.serverTimestamp});

  factory IGetSyncAllUsersRes.fromJson(Map<String, dynamic> json) => IGetSyncAllUsersRes(
    userVersions: (json['userVersions'] as List?)?.map((e) => IUserVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 好友版本信息
class IFriendVersionItem {
  final String friendId; // 这里 PC 叫 id，但 friend.ts 里用 item.friendId，接口返回可能是 friendId
  final int version;

  IFriendVersionItem({required this.friendId, required this.version});

  factory IFriendVersionItem.fromJson(Map<String, dynamic> json) => IFriendVersionItem(
    friendId: json['id'] ?? json['friendId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取好友同步请求
class IGetSyncFriendsReq {
  final int? since;

  IGetSyncFriendsReq({this.since});

  Map<String, dynamic> toJson() => {
    if (since != null) 'since': since,
  };
}

/// 获取好友同步响应
class IGetSyncFriendsRes {
  final List<IFriendVersionItem> friendVersions;
  final int serverTimestamp;

  IGetSyncFriendsRes({required this.friendVersions, required this.serverTimestamp});

  factory IGetSyncFriendsRes.fromJson(Map<String, dynamic> json) => IGetSyncFriendsRes(
    friendVersions: (json['friendVersions'] as List?)?.map((e) => IFriendVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 好友验证版本信息
class IFriendVerifyVersionItem {
  final String verifyId;
  final int version;

  IFriendVerifyVersionItem({required this.verifyId, required this.version});

  factory IFriendVerifyVersionItem.fromJson(Map<String, dynamic> json) => IFriendVerifyVersionItem(
    verifyId: json['verifyId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取好友验证同步请求
class IGetSyncFriendVerifiesReq {
  final int? since;

  IGetSyncFriendVerifiesReq({this.since});

  Map<String, dynamic> toJson() => {
    if (since != null) 'since': since,
  };
}

/// 获取好友验证同步响应
class IGetSyncFriendVerifiesRes {
  final List<IFriendVerifyVersionItem> friendVerifyVersions;
  final int serverTimestamp;

  IGetSyncFriendVerifiesRes({required this.friendVerifyVersions, required this.serverTimestamp});

  factory IGetSyncFriendVerifiesRes.fromJson(Map<String, dynamic> json) => IGetSyncFriendVerifiesRes(
    friendVerifyVersions: (json['friendVerifyVersions'] as List?)?.map((e) => IFriendVerifyVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 表情版本信息
class IEmojiVersionItem {
  final String emojiId;
  final int version;

  IEmojiVersionItem({required this.emojiId, required this.version});

  factory IEmojiVersionItem.fromJson(Map<String, dynamic> json) => IEmojiVersionItem(
    emojiId: json['emojiId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取表情同步请求
class IGetSyncEmojisReq {
  final int since;
  IGetSyncEmojisReq({required this.since});
  Map<String, dynamic> toJson() => {'since': since};
}

/// 获取表情同步响应
class IGetSyncEmojisRes {
  final List<IEmojiVersionItem> emojiVersions;
  final int serverTimestamp;

  IGetSyncEmojisRes({required this.emojiVersions, required this.serverTimestamp});

  factory IGetSyncEmojisRes.fromJson(Map<String, dynamic> json) => IGetSyncEmojisRes(
    emojiVersions: (json['emojiVersions'] as List?)?.map((e) => IEmojiVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 获取通知事件同步请求
class IGetSyncNotificationEventsReq {
  final int sinceVersion;
  final int? limit;
  IGetSyncNotificationEventsReq({required this.sinceVersion, this.limit});
  Map<String, dynamic> toJson() => {
    'sinceVersion': sinceVersion,
    if (limit != null) 'limit': limit,
  };
}

/// 通知事件版本信息
class INotificationEventVersionItem {
  final String eventId;
  final int version;

  INotificationEventVersionItem({required this.eventId, required this.version});

  factory INotificationEventVersionItem.fromJson(Map<String, dynamic> json) => INotificationEventVersionItem(
    eventId: json['eventId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取通知事件同步响应
class IGetSyncNotificationEventsRes {
  final List<INotificationEventVersionItem> eventVersions;
  final int maxVersion;
  final int serverTimestamp;

  IGetSyncNotificationEventsRes({
    required this.eventVersions,
    required this.maxVersion,
    required this.serverTimestamp,
  });

  factory IGetSyncNotificationEventsRes.fromJson(Map<String, dynamic> json) => IGetSyncNotificationEventsRes(
    eventVersions: (json['eventVersions'] as List?)?.map((e) => INotificationEventVersionItem.fromJson(e)).toList() ?? [],
    maxVersion: json['maxVersion'] ?? 0,
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 群组信息版本信息
class IGroupInfoVersionItem {
  final String groupId;
  final int version;

  IGroupInfoVersionItem({required this.groupId, required this.version});

  factory IGroupInfoVersionItem.fromJson(Map<String, dynamic> json) => IGroupInfoVersionItem(
    groupId: json['groupId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取群组信息同步请求
class IGetSyncGroupInfoReq {
  final int? since;

  IGetSyncGroupInfoReq({this.since});

  Map<String, dynamic> toJson() => {
    if (since != null) 'since': since,
  };
}

/// 获取群组信息同步响应
class IGetSyncGroupInfoRes {
  final List<IGroupInfoVersionItem> groupVersions;
  final int serverTimestamp;

  IGetSyncGroupInfoRes({required this.groupVersions, required this.serverTimestamp});

  factory IGetSyncGroupInfoRes.fromJson(Map<String, dynamic> json) => IGetSyncGroupInfoRes(
    groupVersions: (json['groupVersions'] as List?)?.map((e) => IGroupInfoVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 聊天消息版本信息
class IChatMessageVersionItem {
  final String conversationId;
  final int seq;

  IChatMessageVersionItem({required this.conversationId, required this.seq});

  factory IChatMessageVersionItem.fromJson(Map<String, dynamic> json) => IChatMessageVersionItem(
    conversationId: json['conversationId'] ?? '',
    seq: json['seq'] ?? 0,
  );
}

/// 获取聊天消息同步请求
class IGetSyncChatMessagesReq {
  final int? since;

  IGetSyncChatMessagesReq({this.since});

  Map<String, dynamic> toJson() => {
    if (since != null) 'since': since,
  };
}

/// 获取聊天消息同步响应
class IGetSyncChatMessagesRes {
  final List<IChatMessageVersionItem> messageVersions;
  final int serverTimestamp;

  IGetSyncChatMessagesRes({required this.messageVersions, required this.serverTimestamp});

  factory IGetSyncChatMessagesRes.fromJson(Map<String, dynamic> json) => IGetSyncChatMessagesRes(
    messageVersions: (json['messageVersions'] as List?)?.map((e) => IChatMessageVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 会话元数据版本项
class IConversationVersionItem {
  final String conversationId;
  final int version;

  IConversationVersionItem({required this.conversationId, required this.version});

  factory IConversationVersionItem.fromJson(Map<String, dynamic> json) => IConversationVersionItem(
    conversationId: json['conversationId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取会话摘要同步请求
class IGetSyncChatConversationsReq {
  final int? since;
  IGetSyncChatConversationsReq({this.since});
  Map<String, dynamic> toJson() => {if (since != null) 'since': since};
}

/// 获取会话摘要同步响应
class IGetSyncChatConversationsRes {
  final List<IConversationVersionItem> conversationVersions;
  final int serverTimestamp;

  IGetSyncChatConversationsRes({required this.conversationVersions, required this.serverTimestamp});

  factory IGetSyncChatConversationsRes.fromJson(Map<String, dynamic> json) => IGetSyncChatConversationsRes(
    conversationVersions: (json['conversationVersions'] as List?)?.map((e) => IConversationVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 用户会话设置版本项
class IUserConversationVersionItem {
  final String conversationId;
  final int version;

  IUserConversationVersionItem({required this.conversationId, required this.version});

  factory IUserConversationVersionItem.fromJson(Map<String, dynamic> json) => IUserConversationVersionItem(
    conversationId: json['conversationId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取用户会话设置摘要请求
class IGetSyncChatUserConversationsReq {
  final int? since;
  IGetSyncChatUserConversationsReq({this.since});
  Map<String, dynamic> toJson() => {if (since != null) 'since': since};
}

/// 获取用户会话设置摘要响应
class IGetSyncChatUserConversationsRes {
  final List<IUserConversationVersionItem> userConversationVersions;
  final int serverTimestamp;

  IGetSyncChatUserConversationsRes({required this.userConversationVersions, required this.serverTimestamp});

  factory IGetSyncChatUserConversationsRes.fromJson(Map<String, dynamic> json) => IGetSyncChatUserConversationsRes(
    userConversationVersions: (json['userConversationVersions'] as List?)?.map((e) => IUserConversationVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 群成员版本项
class IGroupMembersVersionItem {
  final String groupId;
  final int version;

  IGroupMembersVersionItem({required this.groupId, required this.version});

  factory IGroupMembersVersionItem.fromJson(Map<String, dynamic> json) => IGroupMembersVersionItem(
    groupId: json['groupId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取群成员摘要响应
class IGetSyncGroupMembersRes {
  final List<IGroupMembersVersionItem> groupVersions;
  final int serverTimestamp;

  IGetSyncGroupMembersRes({required this.groupVersions, required this.serverTimestamp});

  factory IGetSyncGroupMembersRes.fromJson(Map<String, dynamic> json) => IGetSyncGroupMembersRes(
    groupVersions: (json['groupVersions'] as List?)?.map((e) => IGroupMembersVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 获取群成员摘要请求
class IGetSyncGroupMembersReq {
  final int? since;
  IGetSyncGroupMembersReq({this.since});
  Map<String, dynamic> toJson() => {if (since != null) 'since': since};
}

/// 入群申请版本项
class IGroupRequestsVersionItem {
  final String groupId;
  final int version;

  IGroupRequestsVersionItem({required this.groupId, required this.version});

  factory IGroupRequestsVersionItem.fromJson(Map<String, dynamic> json) => IGroupRequestsVersionItem(
    groupId: json['groupId'] ?? '',
    version: json['version'] ?? 0,
  );
}

/// 获取入群申请摘要响应
class IGetSyncGroupRequestsRes {
  final List<IGroupRequestsVersionItem> groupVersions;
  final int serverTimestamp;

  IGetSyncGroupRequestsRes({required this.groupVersions, required this.serverTimestamp});

  factory IGetSyncGroupRequestsRes.fromJson(Map<String, dynamic> json) => IGetSyncGroupRequestsRes(
    groupVersions: (json['groupVersions'] as List?)?.map((e) => IGroupRequestsVersionItem.fromJson(e)).toList() ?? [],
    serverTimestamp: json['serverTimestamp'] ?? 0,
  );
}

/// 获取入群申请摘要请求
class IGetSyncGroupRequestsReq {
  final int? since;
  IGetSyncGroupRequestsReq({this.since});
  Map<String, dynamic> toJson() => {if (since != null) 'since': since};
}
