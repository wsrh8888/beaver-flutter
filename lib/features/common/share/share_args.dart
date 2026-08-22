/// 实体分享入参（群 / 圈等，对齐 PC Share cardType）
class EntityShareArgs {
  /// 1=个人 2=群 3=圈子
  final int cardType;
  final String id;
  final String name;
  final String inviteUrl;
  final String? avatar;

  const EntityShareArgs({
    required this.cardType,
    required this.id,
    required this.name,
    required this.inviteUrl,
    this.avatar,
  });

  bool get isGroup => cardType == 2;
  bool get isCircle => cardType == 3;

  String get title {
    if (isGroup) return '分享群聊';
    if (isCircle) return '分享圈子';
    return '分享';
  }

  String get cardTabLabel {
    if (isGroup) return '群名片';
    if (isCircle) return '圈子名片';
    return '名片';
  }

  String get qrTabLabel {
    if (isGroup) return '群二维码';
    if (isCircle) return '圈子二维码';
    return '二维码';
  }

  String get cardHint {
    if (isGroup) return '分享后对方可一键加入群聊';
    if (isCircle) return '分享后对方可一键加入圈子';
    return '分享给好友';
  }

  String get entityLabel {
    if (isGroup) return '群聊';
    if (isCircle) return '圈子';
    return '名片';
  }
}
