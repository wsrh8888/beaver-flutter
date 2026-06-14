import 'package:beaver/core/database/db.dart';
import 'package:drift/drift.dart';
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

  factory IFriendSyncItem.fromJson(Map<String, dynamic> json) =>
      IFriendSyncItem(
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

  FriendsCompanion toCompanion() => FriendsCompanion(
    friendId: Value(friendId),
    sendUserId: Value(sendUserId),
    revUserId: Value(revUserId),
    sendUserNotice: Value(sendUserNotice),
    revUserNotice: Value(revUserNotice),
    source: Value(source),
    isDeleted: Value(isDeleted ? 1 : 0),
    version: Value(version),
    createdAt: Value(createdAt),
    updatedAt: Value(updatedAt),
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

  factory IFriendVerifySyncItem.fromJson(Map<String, dynamic> json) =>
      IFriendVerifySyncItem(
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

  FriendVerifiesCompanion toCompanion() => FriendVerifiesCompanion(
    verifyId: Value(verifyId),
    sendUserId: Value(sendUserId),
    revUserId: Value(revUserId),
    sendStatus: Value(sendStatus),
    revStatus: Value(revStatus),
    message: Value(message),
    source: Value(source),
    version: Value(version),
    createdAt: Value(createdAt),
    updatedAt: Value(updatedAt),
  );
}

/// 好友同步响应
class IFriendSyncRes {
  final List<IFriendSyncItem> friends;
  IFriendSyncRes({required this.friends});
  factory IFriendSyncRes.fromJson(Map<String, dynamic> json) => IFriendSyncRes(
    friends:
        (json['friends'] as List?)
            ?.map((e) => IFriendSyncItem.fromJson(e))
            .toList() ??
        [],
  );
}

/// 好友验证同步响应
class IFriendVerifySyncRes {
  final List<IFriendVerifySyncItem> verifies;
  IFriendVerifySyncRes({required this.verifies});
  factory IFriendVerifySyncRes.fromJson(Map<String, dynamic> json) =>
      IFriendVerifySyncRes(
        verifies:
            (json['verifies'] as List?)
                ?.map((e) => IFriendVerifySyncItem.fromJson(e))
                .toList() ??
            [],
      );
}

/// 好友同步请求 (用于 UserSync/FriendSync logic)
class IFriendSyncReq {
  final List<IFriendVersionItem> friendVersions;
  IFriendSyncReq({required this.friendVersions});
  Map<String, dynamic> toJson() => {
    'friendVersions': friendVersions
        .map((e) => {'friendId': e.friendId, 'version': e.version})
        .toList(),
  };
}

/// 批量获取好友数据请求
class IGetFriendsListByIdsReq {
  final List<String> friendIds;
  IGetFriendsListByIdsReq({required this.friendIds});
  Map<String, dynamic> toJson() => {'friendIds': friendIds};
}

/// 批量获取好友数据响应
class IGetFriendsListByIdsRes {
  final List<IFriendSyncItem> friends;
  IGetFriendsListByIdsRes({required this.friends});
  factory IGetFriendsListByIdsRes.fromJson(Map<String, dynamic> json) =>
      IGetFriendsListByIdsRes(
        friends:
            (json['friends'] as List?)
                ?.map((e) => IFriendSyncItem.fromJson(e))
                .toList() ??
            [],
      );
}

/// 批量获取好友验证数据请求
class IGetFriendVerifiesListByIdsReq {
  final List<String> verifyIds;
  IGetFriendVerifiesListByIdsReq({required this.verifyIds});
  Map<String, dynamic> toJson() => {'verifyIds': verifyIds};
}

/// 批量获取好友验证数据响应
class IGetFriendVerifiesListByIdsRes {
  final List<IFriendVerifySyncItem> friendVerifies;
  IGetFriendVerifiesListByIdsRes({required this.friendVerifies});
  factory IGetFriendVerifiesListByIdsRes.fromJson(Map<String, dynamic> json) =>
      IGetFriendVerifiesListByIdsRes(
        friendVerifies:
            (json['friendVerifies'] as List?)
                ?.map((e) => IFriendVerifySyncItem.fromJson(e))
                .toList() ??
            [],
      );
}

/// 搜索用户请求
class ISearchUserReq {
  final String keyword;
  final String? type;

  ISearchUserReq({required this.keyword, this.type});

  Map<String, dynamic> toJson() => {
    'keyword': keyword,
    if (type != null) 'type': type,
  };
}

/// 搜索用户响应
class IResSearchUserInfo {
  final String userId;
  final String nickName;
  final String avatar;
  final String abstract;
  final String notice;
  final bool isFriend;
  final String? conversationId;
  final String? email;

  IResSearchUserInfo({
    required this.userId,
    required this.nickName,
    required this.avatar,
    required this.abstract,
    required this.notice,
    required this.isFriend,
    this.conversationId,
    this.email,
  });

  factory IResSearchUserInfo.fromJson(Map<String, dynamic> json) =>
      IResSearchUserInfo(
        userId: json['userId'] ?? '',
        nickName: json['nickName'] ?? '',
        avatar: json['avatar'] ?? '',
        abstract: json['abstract'] ?? '',
        notice: json['notice'] ?? '',
        isFriend: json['isFriend'] ?? false,
        conversationId: json['conversationId'],
        email: json['email'],
      );
}

/// 申请添加好友请求
class IAddFriendReq {
  final String friendId;
  final String? verify;
  final String? source;

  IAddFriendReq({required this.friendId, this.verify, this.source});

  Map<String, dynamic> toJson() => {
    'friendId': friendId,
    if (verify != null) 'verify': verify,
    if (source != null) 'source': source,
  };
}

/// 修改好友备注请求
class INoticeUpdateReq {
  final String friendId;
  final String notice;

  INoticeUpdateReq({required this.friendId, required this.notice});

  Map<String, dynamic> toJson() => {
    'friendId': friendId,
    'notice': notice,
  };
}

/// 修改好友备注响应
class INoticeUpdateRes {
  INoticeUpdateRes();

  factory INoticeUpdateRes.fromJson(Map<String, dynamic> json) =>
      INoticeUpdateRes();
}

/// 验证好友申请请求
class IValiFriendReq {
  final String verifyId;
  final int status; // 1: 接受, 2: 拒绝

  IValiFriendReq({required this.verifyId, required this.status});

  Map<String, dynamic> toJson() => {'verifyId': verifyId, 'status': status};
}
