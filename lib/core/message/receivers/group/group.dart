import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/core/business/group/group_member.dart';
import 'package:beaver/di/injection.dart';

/// 群组接收器 - 处理 groups 表的操作 (对标 PC receivers/group/group.ts)
class GroupReceiver {
  GroupBusiness get _groupBusiness => getIt<GroupBusiness>();

  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final updates = (body['tables'] ?? body['tableUpdates']) as List?;
    if (updates == null) return;

    for (final update in updates) {
      final table = update['table'] as String?;
      final conversationId = update['conversationId']?.toString();
      final groupId = update['groupId']?.toString();
      final userId = update['userId']?.toString();
      final data = update['data'] as List?;

      if (data == null) continue;

      if (table == 'groups' || table == 'group') {
        for (final item in data) {
          final itemGroupId =
              item['groupId']?.toString() ??
              groupId ??
              conversationId?.replaceFirst('group_', '');
          final version = item['version'] as int?;

          if (itemGroupId != null && version != null) {
            await _groupBusiness.syncGroupByVersion(itemGroupId, version);
          }
        }
      } else if (table == 'group_members') {
        for (final item in data) {
          final itemGroupId =
              item['groupId']?.toString() ??
              groupId ??
              conversationId?.replaceFirst('group_', '');
          final itemUserId = item['userId']?.toString() ?? userId;
          final version = item['version'] as int?;

          if (itemGroupId != null && itemUserId != null && version != null) {
            await getIt<GroupMemberBusiness>().handleTableUpdates(
              itemUserId,
              itemGroupId,
              version,
            );
          }
        }
      }
    }
  }
}

final groupReceiver = GroupReceiver();
