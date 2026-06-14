import 'package:equatable/equatable.dart';
import 'package:beaver/core/database/db.dart';

/// 用户仓库接口
abstract class UserRepositoryInterface {
  Future<User?> getUserProfile(String userId);
  Future<UserInfo> getMyUserInfo();
  Future<bool> updateProfile({
    String? nickname,
    String? avatar,
    String? abstract,
    int? gender,
  });
  Future<bool> getEmailCode(String email, String type);
  Future<bool> updateEmail(String email, String code);
}

/// 用户信息模型 (UI)
class UserInfo extends Equatable {
  final String userId;
  final String nickname;
  final String? avatar;
  final String? abstract;
  final String? email;
  final String? phone;
  final int gender;

  const UserInfo({
    required this.userId,
    required this.nickname,
    this.avatar,
    this.abstract,
    this.email,
    this.phone,
    this.gender = 0,
  });

  @override
  List<Object?> get props => [
    userId,
    nickname,
    avatar,
    abstract,
    email,
    phone,
    gender,
  ];


  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      userId: map['userId'] ?? '',
      nickname: map['nickname'] ?? 'Beaver',
      avatar: map['avatar'],
      abstract: map['abstract'],
      email: map['email'],
      phone: map['phone'],
      gender: map['gender'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nickname': nickname,
      'avatar': avatar,
      'abstract': abstract,
      'email': email,
      'phone': phone,
      'gender': gender,
    };
  }

  UserInfo copyWith({
    String? userId,
    String? nickname,
    String? avatar,
    String? abstract,
    String? email,
    String? phone,
    int? gender,
  }) {
    return UserInfo(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      abstract: abstract ?? this.abstract,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
    );
  }
}
