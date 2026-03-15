/// 用户信息响应
class IUserInfoRes {
  final String userId;
  final String nickName;
  final String avatar;
  final String abstract;
  final String? phone;
  final String? email;
  final int gender;

  IUserInfoRes({
    required this.userId,
    required this.nickName,
    required this.avatar,
    required this.abstract,
    this.phone,
    this.email,
    required this.gender,
  });

  factory IUserInfoRes.fromJson(Map<String, dynamic> json) => IUserInfoRes(
    userId: json['userId'] ?? '',
    nickName: json['nickName'] ?? '',
    avatar: json['avatar'] ?? '',
    abstract: json['abstract'] ?? '',
    phone: json['phone'],
    email: json['email'],
    gender: json['gender'] ?? 0,
  );
}

/// 用户数据同步项
class IUserSyncItem {
  final String userId;
  final String nickName;
  final String avatar;
  final String abstract;
  final String phone;
  final String email;
  final int gender;
  final int status;
  final int version;
  final int createdAt;
  final int updatedAt;

  IUserSyncItem({
    required this.userId,
    required this.nickName,
    required this.avatar,
    required this.abstract,
    required this.phone,
    required this.email,
    required this.gender,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IUserSyncItem.fromJson(Map<String, dynamic> json) => IUserSyncItem(
    userId: json['userId'] ?? '',
    nickName: json['nickName'] ?? '',
    avatar: json['avatar'] ?? '',
    abstract: json['abstract'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    gender: json['gender'] ?? 0,
    status: json['status'] ?? 0,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? 0,
    updatedAt: json['updatedAt'] ?? 0,
  );
}

/// 用户数据同步请求
class IUserSyncReq {
  final List<IUserVersionItem> userVersions;

  IUserSyncReq({required this.userVersions});

  Map<String, dynamic> toJson() => {
    'userVersions': userVersions.map((v) => {'userId': v.userId, 'version': v.version}).toList(),
  };
}

/// 用户数据同步响应
class IUserSyncRes {
  final List<IUserSyncItem> users;

  IUserSyncRes({required this.users});

  factory IUserSyncRes.fromJson(Map<String, dynamic> json) => IUserSyncRes(
    users: (json['users'] as List?)?.map((e) => IUserSyncItem.fromJson(e)).toList() ?? [],
  );
}

class IUserVersionItem {
  final String userId;
  final int version;

  IUserVersionItem({required this.userId, required this.version});
}
