class ICircleListItem {
  final String circleId;
  final String name;
  final String? avatar;
  final String? description;
  final int memberCount;
  final int? postCount;
  final int? joinType;
  final int role;

  const ICircleListItem({
    required this.circleId,
    required this.name,
    this.avatar,
    this.description,
    required this.memberCount,
    this.postCount,
    this.joinType,
    required this.role,
  });

  factory ICircleListItem.fromJson(Map<String, dynamic> json) {
    return ICircleListItem(
      circleId: json['circleId'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      description: json['description'],
      memberCount: json['memberCount'] ?? 0,
      postCount: json['postCount'],
      joinType: json['joinType'],
      role: json['role'] ?? 0,
    );
  }
}

class ICirclePostFile {
  final String fileKey;
  final int type;

  const ICirclePostFile({required this.fileKey, required this.type});

  factory ICirclePostFile.fromJson(Map<String, dynamic> json) {
    return ICirclePostFile(
      fileKey: json['fileKey'] ?? '',
      type: json['type'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'fileKey': fileKey,
        'type': type,
      };
}

class ICircleCommentItem {
  final String commentId;
  final String userId;
  final String userName;
  final String avatar;
  final String content;
  final String parentId;
  final String replyToCommentId;
  final String replyToUserName;
  final int childCount;
  final List<ICircleCommentItem> children;
  final String createdAt;

  const ICircleCommentItem({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.content,
    this.parentId = '',
    this.replyToCommentId = '',
    this.replyToUserName = '',
    this.childCount = 0,
    this.children = const [],
    required this.createdAt,
  });

  factory ICircleCommentItem.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'] as List<dynamic>? ?? [];
    return ICircleCommentItem(
      commentId: json['commentId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      content: json['content'] ?? '',
      parentId: json['parentId'] ?? '',
      replyToCommentId: json['replyToCommentId'] ?? '',
      replyToUserName: json['replyToUserName'] ?? '',
      childCount: json['childCount'] ?? 0,
      children: rawChildren
          .map((e) => ICircleCommentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] ?? '',
    );
  }

  ICircleCommentItem copyWith({
    int? childCount,
    List<ICircleCommentItem>? children,
  }) {
    return ICircleCommentItem(
      commentId: commentId,
      userId: userId,
      userName: userName,
      avatar: avatar,
      content: content,
      parentId: parentId,
      replyToCommentId: replyToCommentId,
      replyToUserName: replyToUserName,
      childCount: childCount ?? this.childCount,
      children: children ?? this.children,
      createdAt: createdAt,
    );
  }
}

class ICirclePreviewComment {
  final String commentId;
  final String userId;
  final String userName;
  final String content;
  final String createdAt;

  const ICirclePreviewComment({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  factory ICirclePreviewComment.fromJson(Map<String, dynamic> json) {
    return ICirclePreviewComment(
      commentId: json['commentId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class ICirclePostItem {
  final String postId;
  final String circleId;
  final String userId;
  final String userName;
  final String avatar;
  final String title;
  final String content;
  final List<ICirclePostFile> files;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final bool isTop;
  final List<ICirclePreviewComment> comments;
  final String createdAt;

  const ICirclePostItem({
    required this.postId,
    required this.circleId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.title,
    required this.content,
    this.files = const [],
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    this.isTop = false,
    this.comments = const [],
    required this.createdAt,
  });

  factory ICirclePostItem.fromJson(Map<String, dynamic> json) {
    final rawFiles = json['files'] as List<dynamic>? ?? [];
    final rawComments = json['comments'] as List<dynamic>? ?? [];
    return ICirclePostItem(
      postId: json['postId'] ?? '',
      circleId: json['circleId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      files: rawFiles
          .map((e) => ICirclePostFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      commentCount: json['commentCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isTop: json['isTop'] ?? false,
      comments: rawComments
          .map((e) => ICirclePreviewComment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] ?? '',
    );
  }

  ICirclePostItem copyWith({
    List<ICirclePostFile>? files,
    int? commentCount,
    int? likeCount,
    bool? isLiked,
    List<ICirclePreviewComment>? comments,
  }) {
    return ICirclePostItem(
      postId: postId,
      circleId: circleId,
      userId: userId,
      userName: userName,
      avatar: avatar,
      title: title,
      content: content,
      files: files ?? this.files,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isTop: isTop,
      comments: comments ?? this.comments,
      createdAt: createdAt,
    );
  }
}

class IGetMyCircleListReq {
  final int page;
  final int limit;

  const IGetMyCircleListReq({required this.page, required this.limit});

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
      };
}

class IGetMyCircleListRes {
  final int count;
  final List<ICircleListItem> list;

  const IGetMyCircleListRes({required this.count, required this.list});

  factory IGetMyCircleListRes.fromJson(Map<String, dynamic> json) {
    final rawList = json['list'] as List<dynamic>? ?? [];
    return IGetMyCircleListRes(
      count: json['count'] ?? 0,
      list: rawList
          .map((item) => ICircleListItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ICreateCircleReq {
  final String name;
  final String? description;
  final String? avatar;
  final int? joinType;

  const ICreateCircleReq({
    required this.name,
    this.description,
    this.avatar,
    this.joinType,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        if (avatar != null) 'avatar': avatar,
        if (joinType != null) 'joinType': joinType,
      };
}

class ICreateCircleRes {
  final String circleId;
  final String name;

  const ICreateCircleRes({required this.circleId, required this.name});

  factory ICreateCircleRes.fromJson(Map<String, dynamic> json) {
    return ICreateCircleRes(
      circleId: json['circleId'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ICircleSyncReq {
  final int version;

  const ICircleSyncReq({required this.version});

  Map<String, dynamic> toJson() => {'version': version};
}

class ICircleSyncItem {
  final String circleId;
  final String name;
  final String avatar;
  final int memberCount;
  final int role;
  final int version;

  const ICircleSyncItem({
    required this.circleId,
    required this.name,
    required this.avatar,
    required this.memberCount,
    required this.role,
    required this.version,
  });

  factory ICircleSyncItem.fromJson(Map<String, dynamic> json) {
    return ICircleSyncItem(
      circleId: json['circleId'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      role: json['role'] ?? 0,
      version: json['version'] ?? 0,
    );
  }
}

class ICircleSyncRes {
  final List<ICircleSyncItem> list;

  const ICircleSyncRes({required this.list});

  factory ICircleSyncRes.fromJson(Map<String, dynamic> json) {
    final raw = json['list'] as List<dynamic>? ?? [];
    return ICircleSyncRes(
      list: raw
          .map((e) => ICircleSyncItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IGetCircleDetailReq {
  final String circleId;

  const IGetCircleDetailReq({required this.circleId});

  Map<String, dynamic> toJson() => {'circleId': circleId};
}

class IGetCircleDetailRes {
  final String circleId;
  final String name;
  final String description;
  final String avatar;
  final int joinType;
  final String creatorId;
  final int memberCount;
  final int postCount;
  final int role;
  final String createdAt;
  /// 成员可见：稳定邀请链接（复制 / 二维码 / 分享共用）
  final String inviteUrl;

  const IGetCircleDetailRes({
    required this.circleId,
    required this.name,
    required this.description,
    required this.avatar,
    required this.joinType,
    required this.creatorId,
    required this.memberCount,
    required this.postCount,
    required this.role,
    required this.createdAt,
    this.inviteUrl = '',
  });

  factory IGetCircleDetailRes.fromJson(Map<String, dynamic> json) {
    return IGetCircleDetailRes(
      circleId: json['circleId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      avatar: json['avatar'] ?? '',
      joinType: json['joinType'] ?? 0,
      creatorId: json['creatorId'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      postCount: json['postCount'] ?? 0,
      role: json['role'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      inviteUrl: json['inviteUrl'] ?? '',
    );
  }
}

class IJoinCircleReq {
  /// 有 inviteCode 时可空
  final String? circleId;
  final String? reason;
  final String? inviteCode;

  const IJoinCircleReq({
    this.circleId,
    this.reason,
    this.inviteCode,
  });

  Map<String, dynamic> toJson() => {
        if (circleId != null && circleId!.isNotEmpty) 'circleId': circleId,
        if (reason != null) 'reason': reason,
        if (inviteCode != null && inviteCode!.isNotEmpty)
          'inviteCode': inviteCode,
      };
}

class IJoinCircleRes {
  final int status;
  final String? circleId;

  const IJoinCircleRes({required this.status, this.circleId});

  factory IJoinCircleRes.fromJson(Map<String, dynamic> json) {
    return IJoinCircleRes(
      status: json['status'] ?? 0,
      circleId: json['circleId'],
    );
  }
}

class IResolveCircleInviteReq {
  final String code;

  const IResolveCircleInviteReq({required this.code});

  Map<String, dynamic> toJson() => {'code': code};
}

class IResolveCircleInviteRes {
  final String code;
  final String circleId;
  final String name;
  final String avatar;
  final String description;
  final int memberCount;
  final int joinType;
  final bool valid;
  final bool alreadyJoined;

  const IResolveCircleInviteRes({
    required this.code,
    required this.circleId,
    required this.name,
    required this.avatar,
    required this.description,
    required this.memberCount,
    required this.joinType,
    required this.valid,
    required this.alreadyJoined,
  });

  factory IResolveCircleInviteRes.fromJson(Map<String, dynamic> json) {
    return IResolveCircleInviteRes(
      code: json['code'] ?? '',
      circleId: json['circleId'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      description: json['description'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      joinType: json['joinType'] ?? 0,
      valid: json['valid'] == true,
      alreadyJoined: json['alreadyJoined'] == true,
    );
  }
}

class IGetPostListReq {
  final String circleId;
  final int page;
  final int limit;

  const IGetPostListReq({
    required this.circleId,
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {
        'circleId': circleId,
        'page': page,
        'limit': limit,
      };
}

class IGetPostListRes {
  final int count;
  final List<ICirclePostItem> list;

  const IGetPostListRes({required this.count, required this.list});

  factory IGetPostListRes.fromJson(Map<String, dynamic> json) {
    final rawList = json['list'] as List<dynamic>? ?? [];
    return IGetPostListRes(
      count: json['count'] ?? 0,
      list: rawList
          .map((item) => ICirclePostItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IGetPostDetailReq {
  final String postId;

  const IGetPostDetailReq({required this.postId});

  Map<String, dynamic> toJson() => {'postId': postId};
}

class IGetPostDetailRes {
  final String postId;
  final String circleId;
  final String userId;
  final String userName;
  final String avatar;
  final String title;
  final String content;
  final List<ICirclePostFile> files;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final bool isTop;
  final List<ICircleCommentItem> comments;
  final String createdAt;

  const IGetPostDetailRes({
    required this.postId,
    required this.circleId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.title,
    required this.content,
    this.files = const [],
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    this.isTop = false,
    this.comments = const [],
    required this.createdAt,
  });

  factory IGetPostDetailRes.fromJson(Map<String, dynamic> json) {
    final rawFiles = json['files'] as List<dynamic>? ?? [];
    final rawComments = json['comments'] as List<dynamic>? ?? [];
    return IGetPostDetailRes(
      postId: json['postId'] ?? '',
      circleId: json['circleId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      files: rawFiles
          .map((e) => ICirclePostFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      commentCount: json['commentCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isTop: json['isTop'] ?? false,
      comments: rawComments
          .map((e) => ICircleCommentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] ?? '',
    );
  }

  IGetPostDetailRes copyWith({
    int? commentCount,
    int? likeCount,
    bool? isLiked,
    List<ICircleCommentItem>? comments,
  }) {
    return IGetPostDetailRes(
      postId: postId,
      circleId: circleId,
      userId: userId,
      userName: userName,
      avatar: avatar,
      title: title,
      content: content,
      files: files,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isTop: isTop,
      comments: comments ?? this.comments,
      createdAt: createdAt,
    );
  }
}

class ICreatePostReq {
  final String circleId;
  final String? title;
  final String content;
  final List<ICirclePostFile>? files;

  const ICreatePostReq({
    required this.circleId,
    this.title,
    required this.content,
    this.files,
  });

  Map<String, dynamic> toJson() => {
        'circleId': circleId,
        if (title != null) 'title': title,
        'content': content,
        if (files != null) 'files': files!.map((e) => e.toJson()).toList(),
      };
}

class ICreatePostRes {
  final String postId;
  final String circleId;
  final String userId;
  final String userName;
  final String avatar;
  final String title;
  final String content;
  final String createdAt;

  const ICreatePostRes({
    required this.postId,
    required this.circleId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory ICreatePostRes.fromJson(Map<String, dynamic> json) {
    return ICreatePostRes(
      postId: json['postId'] ?? '',
      circleId: json['circleId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class ILikePostReq {
  final String postId;
  final bool status;

  const ILikePostReq({required this.postId, required this.status});

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'status': status,
      };
}

class ILikePostRes {
  const ILikePostRes();

  factory ILikePostRes.fromJson(Map<String, dynamic>? json) {
    return const ILikePostRes();
  }
}

class ICreateCircleCommentReq {
  final String postId;
  final String content;
  final String? parentId;
  final String? replyToCommentId;

  const ICreateCircleCommentReq({
    required this.postId,
    required this.content,
    this.parentId,
    this.replyToCommentId,
  });

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'content': content,
        if (parentId != null) 'parentId': parentId,
        if (replyToCommentId != null) 'replyToCommentId': replyToCommentId,
      };
}

class ICreateCircleCommentRes {
  final String commentId;
  final String postId;
  final String userId;
  final String userName;
  final String avatar;
  final String content;
  final String parentId;
  final String replyToCommentId;
  final String replyToUserName;
  final String createdAt;

  const ICreateCircleCommentRes({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.content,
    required this.parentId,
    required this.replyToCommentId,
    required this.replyToUserName,
    required this.createdAt,
  });

  factory ICreateCircleCommentRes.fromJson(Map<String, dynamic> json) {
    return ICreateCircleCommentRes(
      commentId: json['commentId'] ?? '',
      postId: json['postId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      content: json['content'] ?? '',
      parentId: json['parentId'] ?? '',
      replyToCommentId: json['replyToCommentId'] ?? '',
      replyToUserName: json['replyToUserName'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class IGetCircleCommentListReq {
  final String postId;
  final String? parentId;
  final int page;
  final int limit;

  const IGetCircleCommentListReq({
    required this.postId,
    this.parentId,
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {
        'postId': postId,
        if (parentId != null) 'parentId': parentId,
        'page': page,
        'limit': limit,
      };
}

class IGetCircleCommentListRes {
  final int count;
  final List<ICircleCommentItem> list;

  const IGetCircleCommentListRes({required this.count, required this.list});

  factory IGetCircleCommentListRes.fromJson(Map<String, dynamic> json) {
    final rawList = json['list'] as List<dynamic>? ?? [];
    return IGetCircleCommentListRes(
      count: json['count'] ?? 0,
      list: rawList
          .map((e) => ICircleCommentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IDeleteCircleCommentReq {
  final String commentId;

  const IDeleteCircleCommentReq({required this.commentId});

  Map<String, dynamic> toJson() => {'commentId': commentId};
}

class IDeleteCircleCommentRes {
  const IDeleteCircleCommentRes();

  factory IDeleteCircleCommentRes.fromJson(Map<String, dynamic>? json) {
    return const IDeleteCircleCommentRes();
  }
}

class ICircleMemberItem {
  final String userId;
  final String userName;
  final String avatar;
  final int role;

  const ICircleMemberItem({
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.role,
  });

  factory ICircleMemberItem.fromJson(Map<String, dynamic> json) {
    return ICircleMemberItem(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      role: json['role'] ?? 0,
    );
  }
}

class IGetCircleMembersReq {
  final String circleId;
  final int page;
  final int limit;

  const IGetCircleMembersReq({
    required this.circleId,
    this.page = 1,
    this.limit = 100,
  });

  Map<String, dynamic> toJson() => {
        'circleId': circleId,
        'page': page,
        'limit': limit,
      };
}

class IGetCircleMembersRes {
  final int count;
  final List<ICircleMemberItem> list;

  const IGetCircleMembersRes({required this.count, required this.list});

  factory IGetCircleMembersRes.fromJson(Map<String, dynamic> json) {
    final raw = json['list'] as List<dynamic>? ?? [];
    return IGetCircleMembersRes(
      count: json['count'] ?? 0,
      list: raw
          .map((e) => ICircleMemberItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IInviteCircleMembersReq {
  final String circleId;
  final List<String> userIds;

  const IInviteCircleMembersReq({
    required this.circleId,
    required this.userIds,
  });

  Map<String, dynamic> toJson() => {
        'circleId': circleId,
        'userIds': userIds,
      };
}

class IInviteCircleMembersRes {
  const IInviteCircleMembersRes();

  factory IInviteCircleMembersRes.fromJson(Map<String, dynamic>? json) {
    return const IInviteCircleMembersRes();
  }
}

class IRemoveCircleMembersReq {
  final String circleId;
  final List<String> userIds;

  const IRemoveCircleMembersReq({
    required this.circleId,
    required this.userIds,
  });

  Map<String, dynamic> toJson() => {
        'circleId': circleId,
        'userIds': userIds,
      };
}

class IRemoveCircleMembersRes {
  const IRemoveCircleMembersRes();

  factory IRemoveCircleMembersRes.fromJson(Map<String, dynamic>? json) {
    return const IRemoveCircleMembersRes();
  }
}

class IQuitCircleReq {
  final String circleId;

  const IQuitCircleReq({required this.circleId});

  Map<String, dynamic> toJson() => {'circleId': circleId};
}

class IQuitCircleRes {
  const IQuitCircleRes();

  factory IQuitCircleRes.fromJson(Map<String, dynamic>? json) {
    return const IQuitCircleRes();
  }
}

class IDeleteCircleReq {
  final String circleId;

  const IDeleteCircleReq({required this.circleId});

  Map<String, dynamic> toJson() => {'circleId': circleId};
}

class IDeleteCircleRes {
  const IDeleteCircleRes();

  factory IDeleteCircleRes.fromJson(Map<String, dynamic>? json) {
    return const IDeleteCircleRes();
  }
}
