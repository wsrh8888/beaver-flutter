class FriendRequest {
  final int id;
  final String nickname;
  final String fileName;
  final String? message;
  final String source;
  final String flag; // 'receive' or 'send'
  final int status; // 0: pending, 1: accepted, 2: rejected
  final String createdAt;

  const FriendRequest({
    required this.id,
    required this.nickname,
    required this.fileName,
    this.message,
    required this.source,
    required this.flag,
    required this.status,
    required this.createdAt,
  });
}
