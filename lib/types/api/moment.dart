
/// 朋友圈媒体文件模型
class IMomentFileModel {
  final String? fileName;
  final String? url;

  IMomentFileModel({this.fileName, this.url});

  factory IMomentFileModel.fromJson(Map<String, dynamic> json) => IMomentFileModel(
    fileName: json['fileName'],
    url: json['url'],
  );
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

  factory IMomentLikeModel.fromJson(Map<String, dynamic> json) => IMomentLikeModel(
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
  final String content;
  final String? replyUserId;
  final String? replyUserName;
  final String createdAt;

  IMomentCommentModel({
    required this.id,
    required this.momentId,
    required this.userId,
    required this.userName,
    required this.content,
    this.replyUserId,
    this.replyUserName,
    required this.createdAt,
  });

  factory IMomentCommentModel.fromJson(Map<String, dynamic> json) => IMomentCommentModel(
    id: json['id'] ?? '',
    momentId: json['momentId'] ?? '',
    userId: json['userId'] ?? '',
    userName: json['userName'] ?? '',
    content: json['content'] ?? '',
    replyUserId: json['replyUserId'],
    replyUserName: json['replyUserName'],
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

  factory IMomentListItem.fromJson(Map<String, dynamic> json) => IMomentListItem(
    id: json['id'] ?? '',
    userId: json['userId'] ?? '',
    userName: json['userName'] ?? '',
    avatar: json['avatar'],
    content: json['content'] ?? '',
    files: (json['files'] as List?)?.map((e) => IMomentFileModel.fromJson(e)).toList() ?? [],
    likes: (json['likes'] as List?)?.map((e) => IMomentLikeModel.fromJson(e)).toList() ?? [],
    comments: (json['comments'] as List?)?.map((e) => IMomentCommentModel.fromJson(e)).toList() ?? [],
    commentCount: json['commentCount'] ?? 0,
    likeCount: json['likeCount'] ?? 0,
    isLiked: json['isLiked'] ?? false,
    createdAt: json['createdAt'] ?? '',
  );
}

/// 朋友圈列表请求
class IGetMomentListReq {
  final int page;
  final int limit;

  IGetMomentListReq({required this.page, this.limit = 10});

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
  };
}

/// 朋友圈列表响应
class IGetMomentListRes {
  final List<IMomentListItem> list;

  IGetMomentListRes({required this.list});

  factory IGetMomentListRes.fromJson(Map<String, dynamic> json) => IGetMomentListRes(
    list: (json['list'] as List?)?.map((e) => IMomentListItem.fromJson(e)).toList() ?? [],
  );
}

/// 朋友圈点赞请求
class ILikeMomentReq {
  final String momentId;
  final bool status;

  ILikeMomentReq({required this.momentId, required this.status});

  Map<String, dynamic> toJson() => {
    'momentId': momentId,
    'status': status,
  };
}

/// 朋友圈点赞响应
class ILikeMomentRes {
  final bool success;

  ILikeMomentRes({required this.success});

  factory ILikeMomentRes.fromJson(Map<String, dynamic> json) => ILikeMomentRes(
    success: json['success'] ?? false,
  );
}
