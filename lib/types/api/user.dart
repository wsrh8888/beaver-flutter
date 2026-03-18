import 'datasync.dart';

/// 用户同步请求
class IUserSyncReq {
  final List<IUserVersionItem> userVersions;

  IUserSyncReq({required this.userVersions});

  Map<String, dynamic> toJson() => {
    'userVersions': userVersions.map((e) => {'userId': e.userId, 'version': e.version}).toList(),
  };
}

/// 用户同步项
class IUserSyncItem {
  final String userId;
  final String nickName;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? abstract;
  final int gender;
  final int status;
  final int version;
  final int? createdAt;
  final int? updatedAt;

  IUserSyncItem({
    required this.userId,
    required this.nickName,
    this.email,
    this.phone,
    this.avatar,
    this.abstract,
    required this.gender,
    required this.status,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory IUserSyncItem.fromJson(Map<String, dynamic> json) => IUserSyncItem(
    userId: json['userId'] ?? '',
    nickName: json['nickName'] ?? '',
    email: json['email'],
    phone: json['phone'],
    avatar: json['avatar'],
    abstract: json['abstract'],
    gender: json['gender'] ?? 3,
    status: json['status'] ?? 1,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}

/// 用户同步响应
class IUserSyncRes {
  final List<IUserSyncItem> users;

  IUserSyncRes({required this.users});

  factory IUserSyncRes.fromJson(Map<String, dynamic> json) => IUserSyncRes(
    users: (json['users'] as List?)?.map((e) => IUserSyncItem.fromJson(e)).toList() ?? [],
  );
}
