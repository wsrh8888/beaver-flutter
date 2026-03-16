class SearchResult {
  final String userId;
  final String nickname;
  final String fileName;
  final String abstract;
  final String notice;
  final bool isFriend;
  final String conversationId;
  final String email;

  const SearchResult({
    required this.userId,
    required this.nickname,
    required this.fileName,
    required this.abstract,
    required this.notice,
    required this.isFriend,
    required this.conversationId,
    required this.email,
  });
}
