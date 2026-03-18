
/// 用户信息模型 (UI)
class UserInfo {
  final String userId;
  final String nickname;
  final String? avatar;

  const UserInfo({
    required this.userId,
    required this.nickname,
    this.avatar,
  });

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      userId: map['userId'] ?? '',
      nickname: map['nickname'] ?? 'Beaver',
      avatar: map['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nickname': nickname,
      'avatar': avatar,
    };
  }
}
