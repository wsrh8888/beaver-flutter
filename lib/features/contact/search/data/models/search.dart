class User {
  final String userId;
  final String nickname;
  final String? avatar;
  final String? bio;

  const User({
    required this.userId,
    required this.nickname,
    this.avatar,
    this.bio,
  });
}
