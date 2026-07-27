import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/core/business/group/group_member.dart';
import 'package:beaver/di/injection.dart';

/// 群成员接收器 - 处理 groups / group_members 表的操作 (对标 PC group-member-receiver.ts)
class GroupMemberReceiver {
  GroupBusiness get _groupBusiness => getIt<GroupBusiness>();
  GroupMemberBusiness get _groupMemberBusiness => getIt<GroupMemberBusiness>();

  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final updates = (body['tables'] ?? body['tableUpdates']) as List?;
    if (updates == null) return;

    for (final update in updates) {
      final table = update['table'] as String?;
      final userId = update['userId']?.toString();
      final groupId = update['groupId']?.toString() ??
          update['conversationId']?.toString().replaceFirst('group_', '');
      final data = update['data'] as List?;
      if (data == null) continue;

      if (table == 'groups') {
        for (final item in data) {
          final itemGroupId = item['groupId']?.toString() ??
              groupId ??
              item['conversationId']?.toString().replaceFirst('group_', '');
          final version = item['version'] as int?;
          if (itemGroupId != null && version != null) {
            await _groupBusiness.syncGroupByVersion(itemGroupId, version);
          }
        }
      } else if (table == 'group_members') {
        for (final item in data) {
          final itemGroupId = item['groupId']?.toString() ??
              groupId ??
              item['conversationId']?.toString().replaceFirst('group_', '');
          final itemUserId = item['userId']?.toString() ?? userId;
          final version = item['version'] as int?;
          if (itemGroupId != null && version != null) {
            await _groupMemberBusiness.handleTableUpdates(
              itemUserId ?? '',
              itemGroupId,
              version,
            );
          }
        }
      }
    }
  }
}

final groupMemberReceiver = GroupMemberReceiver();
