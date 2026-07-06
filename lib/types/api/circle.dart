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

class IJoinCircleReq {
  final String circleId;
  final String? reason;

  const IJoinCircleReq({required this.circleId, this.reason});

  Map<String, dynamic> toJson() => {
        'circleId': circleId,
        if (reason != null) 'reason': reason,
      };
}

class IJoinCircleRes {
  final int status;

  const IJoinCircleRes({required this.status});

  factory IJoinCircleRes.fromJson(Map<String, dynamic> json) {
    return IJoinCircleRes(status: json['status'] ?? 0);
  }
}
