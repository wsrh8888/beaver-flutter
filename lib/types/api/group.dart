/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */


/// 群组同步项
class IGroupSyncItem {
  final String groupId;
  final String title;
  final String avatar;
  final String creatorId;
  final int joinType;
  final int status;
  final String notice;
  final int version;
  final int? createdAt;
  final int? updatedAt;

  IGroupSyncItem({
    required this.groupId,
    required this.title,
    required this.avatar,
    required this.creatorId,
    required this.joinType,
    required this.status,
    this.notice = '',
    required this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory IGroupSyncItem.fromJson(Map<String, dynamic> json) => IGroupSyncItem(
    groupId: json['groupId'] ?? json['id'] ?? '',
    title: json['title'] ?? '',
    avatar: json['avatar'] ?? '',
    creatorId: json['creatorId'] ?? '',
    joinType: json['joinType'] ?? 0,
    status: json['status'] ?? 1,
    notice: json['notice'] ?? '',
    version: json['version'] ?? 0,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}

/// 群组同步响应
class IGroupSyncRes {
  final List<IGroupSyncItem> groups;
  IGroupSyncRes({required this.groups});
  factory IGroupSyncRes.fromJson(Map<String, dynamic> json) => IGroupSyncRes(
    groups: (json['groups'] as List?)?.map((e) => IGroupSyncItem.fromJson(e)).toList() ?? [],
  );
}

/// 群组成员同步项
class IGroupMemberSyncItem {
  final String groupId;
  final String userId;
  final String? nickName;
  final String? avatar;
  final int role;
  final int status;
  final int joinTime;
  final int version;
  final int? createdAt;
  final int? updatedAt;

  IGroupMemberSyncItem({
    required this.groupId,
    required this.userId,
    this.nickName,
    this.avatar,
    required this.role,
    required this.status,
    required this.joinTime,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory IGroupMemberSyncItem.fromJson(Map<String, dynamic> json) => IGroupMemberSyncItem(
    groupId: json['groupId'] ?? '',
    userId: json['userId'] ?? '',
    nickName: json['nickName'],
    avatar: json['avatar'],
    role: json['role'] ?? 0,
    status: json['status'] ?? 1,
    joinTime: json['joinTime'] ?? 0,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}

/// 群组入群申请同步项
class IGroupJoinRequestSyncItem {
  final int id;
  final String requestId;
  final String groupId;
  final String applicantUserId;
  final String? message;
  final int status;
  final int version;
  final int? createdAt;
  final int? updatedAt;

  IGroupJoinRequestSyncItem({
    required this.id,
    required this.requestId,
    required this.groupId,
    required this.applicantUserId,
    this.message,
    required this.status,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory IGroupJoinRequestSyncItem.fromJson(Map<String, dynamic> json) => IGroupJoinRequestSyncItem(
    id: json['id'] ?? 0,
    requestId: json['requestId'] ?? '',
    groupId: json['groupId'] ?? '',
    applicantUserId: json['applicantUserId'] ?? '',
    message: json['message'],
    status: json['status'] ?? 0,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}

/// 群组版本同步项
class IGroupVersionSyncItem {
  final String groupId;
  final int version;

  IGroupVersionSyncItem({
    required this.groupId,
    required this.version,
  });

  factory IGroupVersionSyncItem.fromJson(Map<String, dynamic> json) => IGroupVersionSyncItem(
    groupId: json['groupId'] ?? '',
    version: json['version'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'groupId': groupId,
    'version': version,
  };
}

/// 群组资料同步请求
class IGroupSyncReq {
  final List<IGroupVersionSyncItem> groups;
  IGroupSyncReq({required this.groups});
  Map<String, dynamic> toJson() => {
    'groups': groups.map((e) => e.toJson()).toList(),
  };
}

/// 群成员同步请求
class IGroupMemberSyncReq {
  final List<IGroupVersionSyncItem> groups;
  IGroupMemberSyncReq({required this.groups});
  Map<String, dynamic> toJson() => {
    'groups': groups.map((e) => e.toJson()).toList(),
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

/// 入群申请同步请求
class IGroupJoinRequestSyncReq {
  final List<IGroupVersionSyncItem> groups;
  IGroupJoinRequestSyncReq({required this.groups});
  Map<String, dynamic> toJson() => {
    'groups': groups.map((e) => e.toJson()).toList(),
  };
}

/// 入群申请同步响应
class IGroupJoinRequestSyncRes {
  final List<IGroupJoinRequestSyncItem> groupJoinRequests;
  IGroupJoinRequestSyncRes({required this.groupJoinRequests});
  factory IGroupJoinRequestSyncRes.fromJson(Map<String, dynamic> json) => IGroupJoinRequestSyncRes(
    groupJoinRequests: (json['groupJoinRequests'] as List?)?.map((e) => IGroupJoinRequestSyncItem.fromJson(e)).toList() ?? [],
  );
}

/// 创建群组请求
class IGroupCreateReq {
  final String? title;
  final List<String>? userIdList;

  IGroupCreateReq({this.title, this.userIdList});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (userIdList != null) data['userIdList'] = userIdList;
    return data;
  }
}

/// 创建群组响应
class IGroupCreateRes {
  final String groupId;

  IGroupCreateRes({required this.groupId});

  factory IGroupCreateRes.fromJson(Map<String, dynamic> json) {
    return IGroupCreateRes(
      groupId: json['groupId'] ?? '',
    );
  }
}
/// 添加群成员请求
class IGroupAddMembersReq {
  final String groupId;
  final List<String> userIds;

  IGroupAddMembersReq({required this.groupId, required this.userIds});

  Map<String, dynamic> toJson() => {
    'groupId': groupId,
    'userIds': userIds,
  };
}

/// 移除群成员请求
class IGroupRemoveMembersReq {
  final String groupId;
  final List<String> userIds;

  IGroupRemoveMembersReq({required this.groupId, required this.userIds});

  Map<String, dynamic> toJson() => {
    'groupId': groupId,
    'userIds': userIds,
  };
}

/// 解散群组请求
class IGroupDeleteReq {
  final String groupId;

  IGroupDeleteReq({required this.groupId});

  Map<String, dynamic> toJson() => {'groupId': groupId};
}

/// 退出群组请求
class IGroupQuitReq {
  final String groupId;

  IGroupQuitReq({required this.groupId});

  Map<String, dynamic> toJson() => {'groupId': groupId};
}

/// 获取群信息请求
class IGroupInfoReq {
  final String groupId;

  IGroupInfoReq({required this.groupId});

  Map<String, dynamic> toJson() => {'groupId': groupId};
}

/// 获取群信息响应
class IGroupInfoRes {
  final String groupId;
  final String title;
  final String avatar;
  final int memberCount;
  final String creatorId;
  final String notice;
  final int joinType;
  final int status;
  final String conversationId;
  final int? createdAt;
  final int? updatedAt;
  final int version;
  /// 成员可见：稳定邀请链接
  final String inviteUrl;

  IGroupInfoRes({
    required this.groupId,
    required this.title,
    required this.avatar,
    required this.memberCount,
    required this.creatorId,
    required this.notice,
    required this.joinType,
    required this.status,
    required this.conversationId,
    this.createdAt,
    this.updatedAt,
    required this.version,
    this.inviteUrl = '',
  });

  factory IGroupInfoRes.fromJson(Map<String, dynamic> json) => IGroupInfoRes(
        groupId: json['groupId'] ?? '',
        title: json['title'] ?? '',
        avatar: json['avatar'] ?? '',
        memberCount: json['memberCount'] ?? 0,
        creatorId: json['creatorId'] ?? '',
        notice: json['notice'] ?? '',
        joinType: json['joinType'] ?? 0,
        status: json['status'] ?? 1,
        conversationId: json['conversationId'] ?? '',
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        version: json['version'] ?? 0,
        inviteUrl: json['inviteUrl'] ?? '',
      );
}

/// 申请加入群组请求
class IGroupJoinReq {
  /// 有 inviteCode 时可空
  final String? groupId;
  final String? message;
  final String? inviteCode;

  IGroupJoinReq({this.groupId, this.message, this.inviteCode});

  Map<String, dynamic> toJson() => {
        if (groupId != null && groupId!.isNotEmpty) 'groupId': groupId,
        if (message != null) 'message': message,
        if (inviteCode != null && inviteCode!.isNotEmpty)
          'inviteCode': inviteCode,
      };
}

/// 申请加入群组响应
class IGroupJoinRes {
  final int version;
  final int status;
  final String? groupId;

  IGroupJoinRes({
    required this.version,
    this.status = 1,
    this.groupId,
  });

  factory IGroupJoinRes.fromJson(Map<String, dynamic> json) => IGroupJoinRes(
        version: json['version'] ?? 0,
        status: json['status'] ?? 1,
        groupId: json['groupId'],
      );
}

class IResolveGroupInviteReq {
  final String code;

  IResolveGroupInviteReq({required this.code});

  Map<String, dynamic> toJson() => {'code': code};
}

class IResolveGroupInviteRes {
  final String code;
  final String groupId;
  final String title;
  final String avatar;
  final String notice;
  final int memberCount;
  final int joinType;
  final bool valid;
  final bool alreadyJoined;

  IResolveGroupInviteRes({
    required this.code,
    required this.groupId,
    required this.title,
    required this.avatar,
    required this.notice,
    required this.memberCount,
    required this.joinType,
    required this.valid,
    required this.alreadyJoined,
  });

  factory IResolveGroupInviteRes.fromJson(Map<String, dynamic> json) =>
      IResolveGroupInviteRes(
        code: json['code'] ?? '',
        groupId: json['groupId'] ?? '',
        title: json['title'] ?? '',
        avatar: json['avatar'] ?? '',
        notice: json['notice'] ?? '',
        memberCount: json['memberCount'] ?? 0,
        joinType: json['joinType'] ?? 0,
        valid: json['valid'] == true,
        alreadyJoined: json['alreadyJoined'] == true,
      );
}
