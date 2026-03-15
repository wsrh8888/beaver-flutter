/// 群组同步项
class IGroupSyncItem {
  final String groupId;
  final String title;
  final String avatar;
  final String creatorId;
  final int joinType;
  final int status;
  final int version;
  final int createdAt;
  final int updatedAt;

  IGroupSyncItem({
    required this.groupId,
    required this.title,
    required this.avatar,
    required this.creatorId,
    required this.joinType,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IGroupSyncItem.fromJson(Map<String, dynamic> json) => IGroupSyncItem(
    groupId: json['groupId'] ?? '',
    title: json['title'] ?? '',
    avatar: json['avatar'] ?? '',
    creatorId: json['creatorId'] ?? '',
    joinType: json['joinType'] ?? 0,
    status: json['status'] ?? 0,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? 0,
    updatedAt: json['updatedAt'] ?? 0,
  );
}

/// 群组版本同步项
class IGroupVersionSyncItem {
  final String groupId;
  final int version;

  IGroupVersionSyncItem({required this.groupId, required this.version});

  Map<String, dynamic> toJson() => {
    'groupId': groupId,
    'version': version,
  };
}

/// 群组同步请求
class IGroupSyncReq {
  final List<IGroupVersionSyncItem> groups;

  IGroupSyncReq({required this.groups});

  Map<String, dynamic> toJson() => {
    'groups': groups.map((g) => g.toJson()).toList(),
  };
}

/// 群组同步响应
class IGroupSyncRes {
  final List<IGroupSyncItem> groups;

  IGroupSyncRes({required this.groups});

  factory IGroupSyncRes.fromJson(Map<String, dynamic> json) => IGroupSyncRes(
    groups: (json['groups'] as List?)?.map((e) => IGroupSyncItem.fromJson(e)).toList() ?? [],
  );
}

/// 群成员项
class IGroupMemberSyncItem {
  final String userId;
  final String groupId;
  final String nickName;
  final String avatar;
  final int role;
  final int status;
  final int joinTime; // 这里 PC 是 string，但 PC datasync 映射用了 createdAt/updatedAt 概念，可能实际是 timestamp
  final int version;

  IGroupMemberSyncItem({
    required this.userId,
    required this.groupId,
    required this.nickName,
    required this.avatar,
    required this.role,
    required this.status,
    required this.joinTime,
    required this.version,
  });

  factory IGroupMemberSyncItem.fromJson(Map<String, dynamic> json) => IGroupMemberSyncItem(
    userId: json['userId'] ?? '',
    groupId: json['groupId'] ?? '',
    nickName: json['nickName'] ?? '',
    avatar: json['avatar'] ?? '',
    role: json['role'] ?? 0,
    status: json['status'] ?? 0,
    joinTime: json['joinTime'] is String ? DateTime.parse(json['joinTime']).millisecondsSinceEpoch : (json['joinTime'] ?? 0),
    version: json['version'] ?? 0,
  );
}

/// 群成员同步请求
class IGroupMemberSyncReq {
  final List<IGroupVersionSyncItem> groups;

  IGroupMemberSyncReq({required this.groups});

  Map<String, dynamic> toJson() => {
    'groups': groups.map((g) => g.toJson()).toList(),
  };
}

/// 入群申请同步请求
class IGroupJoinRequestSyncReq {
  final List<IGroupVersionSyncItem> groups;

  IGroupJoinRequestSyncReq({required this.groups});

  Map<String, dynamic> toJson() => {
    'groups': groups.map((g) => g.toJson()).toList(),
  };
}

/// 群成员同步响应
class IGroupMemberSyncRes {
  final List<IGroupMemberSyncItem> groupMembers;

  IGroupMemberSyncRes({required this.groupMembers});

  factory IGroupMemberSyncRes.fromJson(Map<String, dynamic> json) => IGroupMemberSyncRes(
    groupMembers: (json['groupMembers'] as List?)?.map((e) => IGroupMemberSyncItem.fromJson(e)).toList() ?? [],
  );
}

/// 入群申请项
class IGroupJoinRequestSyncItem {
  final int id;
  final String groupId;
  final String applicantUserId;
  final String message;
  final int status;
  final int version;
  final int createdAt;
  final int updatedAt;

  IGroupJoinRequestSyncItem({
    required this.id,
    required this.groupId,
    required this.applicantUserId,
    required this.message,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IGroupJoinRequestSyncItem.fromJson(Map<String, dynamic> json) => IGroupJoinRequestSyncItem(
    id: json['id'] is String ? int.parse(json['id']) : (json['id'] ?? 0),
    groupId: json['groupId'] ?? '',
    applicantUserId: json['applicantUserId'] ?? '',
    message: json['message'] ?? '',
    status: json['status'] ?? 0,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? 0,
    updatedAt: json['updatedAt'] ?? 0,
  );
}

/// 入群申请同步响应
class IGroupJoinRequestSyncRes {
  final List<IGroupJoinRequestSyncItem> groupJoinRequests;

  IGroupJoinRequestSyncRes({required this.groupJoinRequests});

  factory IGroupJoinRequestSyncRes.fromJson(Map<String, dynamic> json) => IGroupJoinRequestSyncRes(
    groupJoinRequests: (json['groupJoinRequests'] as List?)?.map((e) => IGroupJoinRequestSyncItem.fromJson(e)).toList() ?? [],
  );
}
