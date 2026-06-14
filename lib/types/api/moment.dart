/// 朋友圈媒体文件类型
enum MomentType {
  text(1),
  image(2),
  video(3),
  file(4);

  final int value;
  const MomentType(this.value);
}

/// 朋友圈媒体文件模型 (对应 IFileInfo)
class IMomentFileModel {
  final String fileKey;
  final int type; // 2=图片 3=视频 8=音频 4=文件

  IMomentFileModel({required this.fileKey, required this.type});

  factory IMomentFileModel.fromJson(Map<String, dynamic> json) =>
      IMomentFileModel(fileKey: json['fileKey'] ?? '', type: json['type'] ?? 0);

  Map<String, dynamic> toJson() => {'fileKey': fileKey, 'type': type};
}

/// 朋友圈点赞模型
class IMomentLikeModel {
  final String id;
  final String momentId;
  final String userId;
  final String userName;
  final String avatar;
  final String createdAt;

  IMomentLikeModel({
    required this.id,
    required this.momentId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.createdAt,
  });

  factory IMomentLikeModel.fromJson(Map<String, dynamic> json) =>
      IMomentLikeModel(
        id: json['id'] ?? '',
        momentId: json['momentId'] ?? '',
        userId: json['userId'] ?? '',
        userName: json['userName'] ?? '',
        avatar: json['avatar'] ?? '',
        createdAt: json['createdAt'] ?? '',
      );
}

/// 朋友圈评论模型
class IMomentCommentModel {
  final String id;
  final String momentId;
  final String userId;
  final String userName;
  final String? nickName;
  final String? avatar;
  final String content;
  final int? childCount;
  final String? parentId;
  final String? replyToCommentId;
  final String? replyToUserName;
  final List<IMomentCommentModel>? children;
  final String createdAt;

  IMomentCommentModel({
    required this.id,
    required this.momentId,
    required this.userId,
    required this.userName,
    this.nickName,
    this.avatar,
    required this.content,
    this.childCount,
    this.parentId,
    this.replyToCommentId,
    this.replyToUserName,
    this.children,
    required this.createdAt,
  });

  factory IMomentCommentModel.fromJson(Map<String, dynamic> json) =>
      IMomentCommentModel(
        id: json['id'] ?? '',
        momentId: json['momentId'] ?? '',
        userId: json['userId'] ?? '',
        userName: json['userName'] ?? '',
        nickName: json['nickName'],
        avatar: json['avatar'],
        content: json['content'] ?? '',
        childCount: json['childCount'],
        parentId: json['parentId'],
        replyToCommentId: json['replyToCommentId'],
        replyToUserName: json['replyToUserName'],
        children: (json['children'] as List?)
            ?.map((e) => IMomentCommentModel.fromJson(e))
            .toList(),
        createdAt: json['createdAt'] ?? '',
      );
}

/// 朋友圈单条动态数据项
class IMomentListItem {
  final String id;
  final String userId;
  final String userName;
  final String? avatar;
  final String content;
  final List<IMomentFileModel> files;
  final List<IMomentLikeModel> likes;
  final List<IMomentCommentModel> comments;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final String createdAt;

  IMomentListItem({
    required this.id,
    required this.userId,
    required this.userName,
    this.avatar,
    required this.content,
    required this.files,
    required this.likes,
    required this.comments,
    this.commentCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
    required this.createdAt,
  });

  factory IMomentListItem.fromJson(Map<String, dynamic> json) =>
      IMomentListItem(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        userName: json['userName'] ?? '',
        avatar: json['avatar'],
        content: json['content'] ?? '',
        files:
            (json['files'] as List?)
                ?.map((e) => IMomentFileModel.fromJson(e))
                .toList() ??
            [],
        likes:
            (json['likes'] as List?)
                ?.map((e) => IMomentLikeModel.fromJson(e))
                .toList() ??
            [],
        comments:
            (json['comments'] as List?)
                ?.map((e) => IMomentCommentModel.fromJson(e))
                .toList() ??
            [],
        commentCount: json['commentCount'] ?? 0,
        likeCount: json['likeCount'] ?? 0,
        isLiked: json['isLiked'] ?? false,
        createdAt: json['createdAt'] ?? '',
      );
}

/// 朋友圈列表请求
class IGetMomentListReq {
  final String? userId;
  final int page;
  final int limit;

  IGetMomentListReq({this.userId, required this.page, this.limit = 10});

  Map<String, dynamic> toJson() => {
    if (userId != null) 'userId': userId,
    'page': page,
    'limit': limit,
  };
}

/// 朋友圈列表响应
class IGetMomentListRes {
  final int count;
  final List<IMomentListItem> list;

  IGetMomentListRes({required this.count, required this.list});

  factory IGetMomentListRes.fromJson(Map<String, dynamic> json) =>
      IGetMomentListRes(
        count: json['count'] ?? 0,
        list:
            (json['list'] as List?)
                ?.map((e) => IMomentListItem.fromJson(e))
                .toList() ??
            [],
      );
}

/// 创建朋友圈请求
class ICreateMomentReq {
  final String content;
  final List<IMomentFileModel> files;

  ICreateMomentReq({required this.content, required this.files});

  Map<String, dynamic> toJson() => {
    'content': content,
    'files': files.map((e) => e.toJson()).toList(),
  };
}

/// 创建朋友圈响应
class ICreateMomentRes extends IMomentListItem {
  ICreateMomentRes({
    required super.id,
    required super.userId,
    required super.userName,
    super.avatar,
    required super.content,
    required super.files,
    required super.likes,
    required super.comments,
    super.commentCount,
    super.likeCount,
    super.isLiked,
    required super.createdAt,
  });

  factory ICreateMomentRes.fromJson(Map<String, dynamic> json) {
    final item = IMomentListItem.fromJson(json);
    return ICreateMomentRes(
      id: item.id,
      userId: item.userId,
      userName: item.userName,
      avatar: item.avatar,
      content: item.content,
      files: item.files,
      likes: item.likes,
      comments: item.comments,
      commentCount: item.commentCount,
      likeCount: item.likeCount,
      isLiked: item.isLiked,
      createdAt: item.createdAt,
    );
  }
}

/// 点赞朋友圈请求
class ILikeMomentReq {
  final String? userId;
  final String momentId;
  final bool status;

  ILikeMomentReq({this.userId, required this.momentId, required this.status});

  Map<String, dynamic> toJson() => {
    if (userId != null) 'userId': userId,
    'momentId': momentId,
    'status': status,
  };
}

/// 点赞朋友圈响应
class ILikeMomentRes {
  ILikeMomentRes();
  factory ILikeMomentRes.fromJson(Map<String, dynamic> json) => ILikeMomentRes();
}

/// 删除朋友圈请求
class IDeleteMomentReq {
  final String? userId;
  final String momentId;

  IDeleteMomentReq({this.userId, required this.momentId});

  Map<String, dynamic> toJson() => {
    if (userId != null) 'userId': userId,
    'momentId': momentId,
  };
}

/// 创建评论请求
class ICreateMomentCommentReq {
  final String? userId;
  final String momentId;
  final String content;
  final String? parentId;
  final String? replyToCommentId;

  ICreateMomentCommentReq({
    this.userId,
    required this.momentId,
    required this.content,
    this.parentId,
    this.replyToCommentId,
  });

  Map<String, dynamic> toJson() => {
    if (userId != null) 'userId': userId,
    'momentId': momentId,
    'content': content,
    'parentId': parentId ?? '',
    'replyToCommentId': replyToCommentId ?? '',
  };
}

/// 创建评论响应
class ICreateMomentCommentRes {
  final String id;
  final String userId;
  final String userName;
  final String avatar;
  final String content;
  final String parentId;
  final String replyToCommentId;
  final String replyToUserName;
  final String createdAt;

  ICreateMomentCommentRes({
    required this.id,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.content,
    required this.parentId,
    required this.replyToCommentId,
    required this.replyToUserName,
    required this.createdAt,
  });

  factory ICreateMomentCommentRes.fromJson(Map<String, dynamic> json) =>
      ICreateMomentCommentRes(
        id: json['id'] ?? '',
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

/// 获取动态详情请求
class IGetMomentDetailReq {
  final String? userId;
  final String momentId;

  IGetMomentDetailReq({this.userId, required this.momentId});

  Map<String, dynamic> toJson() => {
    if (userId != null) 'userId': userId,
    'momentId': momentId,
  };
}

/// 获取动态详情响应
class IGetMomentDetailRes extends IMomentListItem {
  IGetMomentDetailRes({
    required super.id,
    required super.userId,
    required super.userName,
    super.avatar,
    required super.content,
    required super.files,
    required super.likes,
    required super.comments,
    super.commentCount,
    super.likeCount,
    super.isLiked,
    required super.createdAt,
  });

  factory IGetMomentDetailRes.fromJson(Map<String, dynamic> json) {
    final item = IMomentListItem.fromJson(json);
    return IGetMomentDetailRes(
      id: item.id,
      userId: item.userId,
      userName: item.userName,
      avatar: item.avatar,
      content: item.content,
      files: item.files,
      likes: item.likes,
      comments: item.comments,
      commentCount: item.commentCount,
      likeCount: item.likeCount,
      isLiked: item.isLiked,
      createdAt: item.createdAt,
    );
  }
}

/// 获取动态评论列表请求
class IGetMomentCommentsReq {
  final String? userId;
  final String momentId;
  final String? parentId;
  final int page;
  final int limit;

  IGetMomentCommentsReq({
    this.userId,
    required this.momentId,
    this.parentId,
    required this.page,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() => {
    if (userId != null) 'userId': userId,
    'momentId': momentId,
    if (parentId != null) 'parentId': parentId,
    'page': page,
    'limit': limit,
  };
}

/// 获取动态评论列表响应
class IGetMomentCommentsRes {
  final int count;
  final List<IMomentCommentModel> list;

  IGetMomentCommentsRes({required this.count, required this.list});

  factory IGetMomentCommentsRes.fromJson(Map<String, dynamic> json) =>
      IGetMomentCommentsRes(
        count: json['count'] ?? 0,
        list: (json['list'] as List?)
            ?.map((e) => IMomentCommentModel.fromJson(e))
            .toList() ?? [],
      );
}

/// 获取动态点赞列表请求
class IGetMomentLikesReq {
  final String? userId;
  final String momentId;
  final int page;
  final int limit;

  IGetMomentLikesReq({
    this.userId,
    required this.momentId,
    required this.page,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() => {
    if (userId != null) 'userId': userId,
    'momentId': momentId,
    'page': page,
    'limit': limit,
  };
}

/// 获取动态点赞列表响应
class IGetMomentLikesRes {
  final int count;
  final List<IMomentLikeModel> list;

  IGetMomentLikesRes({required this.count, required this.list});

  factory IGetMomentLikesRes.fromJson(Map<String, dynamic> json) =>
      IGetMomentLikesRes(
        count: json['count'] ?? 0,
        list: (json['list'] as List?)
            ?.map((e) => IMomentLikeModel.fromJson(e))
            .toList() ?? [],
      );
}
