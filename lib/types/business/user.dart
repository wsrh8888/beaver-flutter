
/// 用户信息模型 (UI)
class UserInfo {
  final String userId;
  final String nickname;
  final String? avatar;
  final String? abstract;
  final String? email;
  final int gender;

  const UserInfo({
    required this.userId,
    required this.nickname,
    this.avatar,
    this.abstract,
    this.email,
    this.gender = 0,
  });

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      userId: map['userId'] ?? '',
      nickname: map['nickname'] ?? 'Beaver',
      avatar: map['avatar'],
      abstract: map['abstract'],
      email: map['email'],
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
      'gender': gender,
    };
  }

  UserInfo copyWith({
    String? userId,
    String? nickname,
    String? avatar,
    String? abstract,
    String? email,
    int? gender,
  }) {
    return UserInfo(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      abstract: abstract ?? this.abstract,
      email: email ?? this.email,
      gender: gender ?? this.gender,
    );
  }
}
