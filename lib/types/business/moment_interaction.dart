class MomentInteractionItem {
  final String eventId;
  final String eventType;
  final String fromUserId;
  final String momentId;
  final String? commentId;
  final String? content;
  final int createdAt;
  final bool isRead;

  const MomentInteractionItem({
    required this.eventId,
    required this.eventType,
    required this.fromUserId,
    required this.momentId,
    this.commentId,
    this.content,
    required this.createdAt,
    required this.isRead,
  });

  String get actionText {
    switch (eventType) {
      case 'moment_like':
        return '赞了你的朋友圈';
      case 'moment_comment':
        return '评论了你';
      case 'moment_comment_reply':
        return '回复了你';
      default:
        return '互动了你的朋友圈';
    }
  }
}
