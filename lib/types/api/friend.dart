import 'datasync.dart';

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
  final int? createdAt;
  final int? updatedAt;

  IFriendSyncItem({
    required this.friendId,
    required this.sendUserId,
    required this.revUserId,
    this.sendUserNotice,
    this.revUserNotice,
    this.source,
    required this.isDeleted,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory IFriendSyncItem.fromJson(Map<String, dynamic> json) => IFriendSyncItem(
    friendId: json['id'] ?? json['friendId'] ?? '',
    sendUserId: json['sendUserId'] ?? '',
    revUserId: json['revUserId'] ?? '',
    sendUserNotice: json['sendUserNotice'],
    revUserNotice: json['revUserNotice'],
    source: json['source'],
    isDeleted: json['isDeleted'] ?? false,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}

/// 好友验证同步项
class IFriendVerifySyncItem {
  final String verifyId;
  final String sendUserId;
  final String revUserId;
  final int sendStatus;
  final int revStatus;
  final String? message;
  final String? source;
  final int version;
  final int? createdAt;
  final int? updatedAt;

  IFriendVerifySyncItem({
    required this.verifyId,
    required this.sendUserId,
    required this.revUserId,
    required this.sendStatus,
    required this.revStatus,
    this.message,
    this.source,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory IFriendVerifySyncItem.fromJson(Map<String, dynamic> json) => IFriendVerifySyncItem(
    verifyId: json['verifyId'] ?? '',
    sendUserId: json['sendUserId'] ?? '',
    revUserId: json['revUserId'] ?? '',
    sendStatus: json['sendStatus'] ?? 0,
    revStatus: json['revStatus'] ?? 0,
    message: json['message'],
    source: json['source'],
    version: json['version'] ?? 0,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}

/// 好友同步响应
class IFriendSyncRes {
  final List<IFriendSyncItem> friends;
  IFriendSyncRes({required this.friends});
  factory IFriendSyncRes.fromJson(Map<String, dynamic> json) => IFriendSyncRes(
    friends: (json['friends'] as List?)?.map((e) => IFriendSyncItem.fromJson(e)).toList() ?? [],
  );
}

/// 好友验证同步响应
class IFriendVerifySyncRes {
  final List<IFriendVerifySyncItem> verifies;
  IFriendVerifySyncRes({required this.verifies});
  factory IFriendVerifySyncRes.fromJson(Map<String, dynamic> json) => IFriendVerifySyncRes(
    verifies: (json['verifies'] as List?)?.map((e) => IFriendVerifySyncItem.fromJson(e)).toList() ?? [],
  );
}

/// 好友同步请求 (用于 UserSync/FriendSync logic)
class IFriendSyncReq {
  final List<IFriendVersionItem> friendVersions;
  IFriendSyncReq({required this.friendVersions});
  Map<String, dynamic> toJson() => {
    'friendVersions': friendVersions.map((e) => {'friendId': e.friendId, 'version': e.version}).toList(),
  };
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
