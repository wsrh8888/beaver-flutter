class MomentFile {
  final String fileName;

  const MomentFile(this.fileName);
}

class MomentLike {
  final String userId;
  final String userName;

  const MomentLike(this.userId, this.userName);
}

class Moment {
  final String id;
  final String userName;
  final String fileName;
  final String content;
  final List<MomentFile> files;
  final List<MomentLike> likes;
  final String createdAt;

  const Moment({
    required this.id,
    required this.userName,
    required this.fileName,
    required this.content,
    required this.files,
    required this.likes,
    required this.createdAt,
  });

  Moment copyWith({
    String? id,
    String? userName,
    String? fileName,
    String? content,
    List<MomentFile>? files,
    List<MomentLike>? likes,
    String? createdAt,
  }) {
    return Moment(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      fileName: fileName ?? this.fileName,
      content: content ?? this.content,
      files: files ?? this.files,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
