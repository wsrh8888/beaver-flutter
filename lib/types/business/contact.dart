
class ContactModel {
  final String userId;
  final String nickname;
  final String? notice;
  final String? avatar;
  final String? fileName;

  const ContactModel({
    required this.userId,
    required this.nickname,
    this.notice,
    this.avatar,
    this.fileName,
  });

  ContactModel copyWith({
    String? userId,
    String? nickname,
    String? notice,
    String? avatar,
    String? fileName,
  }) {
    return ContactModel(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      notice: notice ?? this.notice,
      avatar: avatar ?? this.avatar,
      fileName: fileName ?? this.fileName,
    );
  }
}
