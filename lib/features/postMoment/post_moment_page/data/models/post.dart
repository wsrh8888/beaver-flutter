class PostMomentFile {
  final String fileName;

  const PostMomentFile(this.fileName);
}

class PostMomentRequest {
  final String content;
  final List<PostMomentFile> files;

  const PostMomentRequest({
    required this.content,
    required this.files,
  });
}
