class IFileInfo {
  final String fileKey;
  final int type;

  IFileInfo({required this.fileKey, required this.type});

  factory IFileInfo.fromJson(Map<String, dynamic> json) => IFileInfo(
    fileKey: json['fileKey'] ?? '',
    type: json['type'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'fileKey': fileKey,
    'type': type,
  };
}

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

class IMomentCommentModel {
  final String id;
  final String momentId;
  final String userId;
  final String userName;
  final String? nickName;
  final String? avatar;
  final String content;
  final String createdAt;

  IMomentCommentModel({
    required this.id,
    required this.momentId,
    required this.userId,
    required this.userName,
    this.nickName,
    this.avatar,
    required this.content,
    required this.createdAt,
  });

  factory IMomentCommentModel.fromJson(Map<String, dynamic> json) => IMomentCommentModel(
    id: json['id'] ?? '',
    momentId: json['momentId'] ?? '',
    userId: json['userId'] ?? '',
    userName: json['userName'] ?? '',
    nickName: json['nickName'],
    avatar: json['avatar'],
    content: json['content'] ?? '',
    createdAt: json['createdAt'] ?? '',
  );
}

class IMomentListItem {
  final String id;
  final String userId;
  final String userName;
  final String avatar;
  final String content;
  final List<IFileInfo> files;
  final List<IMomentCommentModel> comments;
  final List<IMomentLikeModel> likes;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final String createdAt;

  IMomentListItem({
    required this.id,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.content,
    required this.files,
    required this.comments,
    required this.likes,
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    required this.createdAt,
  });

  factory IMomentListItem.fromJson(Map<String, dynamic> json) {
    return IMomentListItem(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      content: json['content'] ?? '',
      files: (json['files'] as List?)?.map((e) => IFileInfo.fromJson(e)).toList() ?? [],
      comments: (json['comments'] as List?)?.map((e) => IMomentCommentModel.fromJson(e)).toList() ?? [],
      likes: (json['likes'] as List?)?.map((e) => IMomentLikeModel.fromJson(e)).toList() ?? [],
      commentCount: json['commentCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class IGetMomentListReq {
  final int page;
  final int limit;

  IGetMomentListReq({required this.page, required this.limit});

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
  };
}

class IGetMomentListRes {
  final int count;
  final List<IMomentListItem> list;

  IGetMomentListRes({required this.count, required this.list});

  factory IGetMomentListRes.fromJson(Map<String, dynamic> json) => IGetMomentListRes(
    count: json['count'] ?? 0,
    list: (json['list'] as List?)?.map((e) => IMomentListItem.fromJson(e)).toList() ?? [],
  );
}

class ILikeMomentReq {
  final String momentId;
  final bool status;

  ILikeMomentReq({required this.momentId, required this.status});

  Map<String, dynamic> toJson() => {
    'momentId': momentId,
    'status': status,
  };
}

class ILikeMomentRes {
  ILikeMomentRes();
  factory ILikeMomentRes.fromJson(Map<String, dynamic> json) => ILikeMomentRes();
}
