enum PostMomentStatus { initial, loading, success, error }

class PostMomentState {
  final PostMomentStatus status;
  final String content;
  final List<String> mediaList;
  final String? errorMessage;

  const PostMomentState({
    this.status = PostMomentStatus.initial,
    this.content = '',
    this.mediaList = const [],
    this.errorMessage,
  });

  bool get canPost => content.trim().isNotEmpty || mediaList.isNotEmpty;

  PostMomentState copyWith({
    PostMomentStatus? status,
    String? content,
    List<String>? mediaList,
    String? errorMessage,
  }) {
    return PostMomentState(
      status: status ?? this.status,
      content: content ?? this.content,
      mediaList: mediaList ?? this.mediaList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
