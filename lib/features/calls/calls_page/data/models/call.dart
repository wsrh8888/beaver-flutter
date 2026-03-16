class CallInfo {
  final String conversationId;
  final String callerName;
  final String callerAvatar;
  final bool isIncoming;

  const CallInfo({
    required this.conversationId,
    required this.callerName,
    required this.callerAvatar,
    required this.isIncoming,
  });
}
