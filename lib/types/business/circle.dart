/// 圈子本地展示模型（对齐 PC CircleStore）
class CircleInfo {
  final String circleId;
  final String conversationId;
  final String name;
  final String avatar;
  final String description;
  final int memberCount;
  final int role;
  final int joinType;
  final int version;

  const CircleInfo({
    required this.circleId,
    required this.conversationId,
    required this.name,
    required this.avatar,
    this.description = '',
    this.memberCount = 0,
    this.role = 0,
    this.joinType = 0,
    this.version = 0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CircleInfo &&
        other.circleId == circleId &&
        other.conversationId == conversationId &&
        other.name == name &&
        other.avatar == avatar &&
        other.description == description &&
        other.memberCount == memberCount &&
        other.role == role &&
        other.joinType == joinType &&
        other.version == version;
  }

  @override
  int get hashCode => Object.hash(
        circleId,
        conversationId,
        name,
        avatar,
        description,
        memberCount,
        role,
        joinType,
        version,
      );
}
