class UserInfo {
  final String userId;
  final String nickName;
  final String fileName;
  final String email;
  final int gender; // 1: 男, 2: 女, 3: 未知
  final String? abstract;

  const UserInfo({
    required this.userId,
    required this.nickName,
    required this.fileName,
    required this.email,
    required this.gender,
    this.abstract,
  });

  UserInfo copyWith({
    String? userId,
    String? nickName,
    String? fileName,
    String? email,
    int? gender,
    String? abstract,
  }) {
    return UserInfo(
      userId: userId ?? this.userId,
      nickName: nickName ?? this.nickName,
      fileName: fileName ?? this.fileName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      abstract: abstract ?? this.abstract,
    );
  }
}
