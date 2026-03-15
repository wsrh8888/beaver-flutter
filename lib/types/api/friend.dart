/// 好友同步项
class IFriendSyncItem {
  final String friendId;
  final String sendUserId;
  final String revUserId;
  final String? sendUserNotice;
  final String? revUserNotice;
  final String? source;
  final bool isDeleted;
  final int version;
  final int createdAt;
  final int updatedAt;

  IFriendSyncItem({
    required this.friendId,
    required this.sendUserId,
    required this.revUserId,
    this.sendUserNotice,
    this.revUserNotice,
    this.source,
    required this.isDeleted,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IFriendSyncItem.fromJson(Map<String, dynamic> json) => IFriendSyncItem(
    friendId: json['friendId'] ?? '',
    sendUserId: json['sendUserId'] ?? '',
    revUserId: json['revUserId'] ?? '',
    sendUserNotice: json['sendUserNotice'],
    revUserNotice: json['revUserNotice'],
    source: json['source'],
    isDeleted: json['isDeleted'] == true || json['isDeleted'] == 1,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? 0,
    updatedAt: json['updatedAt'] ?? 0,
  );
}

/// 批量获取好友数据请求
class IGetFriendsListByIdsReq {
  final List<String> friendIds;

  IGetFriendsListByIdsReq({required this.friendIds});

  Map<String, dynamic> toJson() => {
    'friendIds': friendIds,
  };
}

/// 批量获取好友数据响应
class IGetFriendsListByIdsRes {
  final List<IFriendSyncItem> friends;

  IGetFriendsListByIdsRes({required this.friends});

  factory IGetFriendsListByIdsRes.fromJson(Map<String, dynamic> json) => IGetFriendsListByIdsRes(
    friends: (json['friends'] as List?)?.map((e) => IFriendSyncItem.fromJson(e)).toList() ?? [],
  );
}

/// 好友验证项
class IFriendVerifySyncItem {
  final String verifyId;
  final String sendUserId;
  final String revUserId;
  final int sendStatus;
  final int revStatus;
  final String message;
  final String source;
  final int version;
  final int createdAt;
  final int updatedAt;

  IFriendVerifySyncItem({
    required this.verifyId,
    required this.sendUserId,
    required this.revUserId,
    required this.sendStatus,
    required this.revStatus,
    required this.message,
    required this.source,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IFriendVerifySyncItem.fromJson(Map<String, dynamic> json) => IFriendVerifySyncItem(
    verifyId: json['verifyId'] ?? '',
    sendUserId: json['sendUserId'] ?? '',
    revUserId: json['revUserId'] ?? '',
    sendStatus: json['sendStatus'] ?? 0,
    revStatus: json['revStatus'] ?? 0,
    message: json['message'] ?? '',
    source: json['source'] ?? '',
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? 0,
    updatedAt: json['updatedAt'] ?? 0,
  );
}

/// 批量获取好友验证数据请求
class IGetFriendVerifiesListByIdsReq {
  final List<String> verifyIds;

  IGetFriendVerifiesListByIdsReq({required this.verifyIds});

  Map<String, dynamic> toJson() => {
    'verifyIds': verifyIds,
  };
}

/// 批量获取好友验证数据响应
class IGetFriendVerifiesListByIdsRes {
  final List<IFriendVerifySyncItem> friendVerifies;

  IGetFriendVerifiesListByIdsRes({required this.friendVerifies});

  factory IGetFriendVerifiesListByIdsRes.fromJson(Map<String, dynamic> json) => IGetFriendVerifiesListByIdsRes(
    friendVerifies: (json['friendVerifies'] as List?)?.map((e) => IFriendVerifySyncItem.fromJson(e)).toList() ?? [],
  );
}
