import 'package:beaver/core/business/group/group_member.dart';
import 'package:beaver/di/injection.dart';

/// 群成员接收器 - 处理 group_members 表的操作 (对标 PC receivers/group/group-member-receiver.ts)
class GroupMemberReceiver {
  GroupMemberBusiness get _groupMemberBusiness => getIt<GroupMemberBusiness>();

  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final updates = (body['tables'] ?? body['tableUpdates']) as List?;
    if (updates == null) return;

    for (final update in updates) {
      final table = update['table'] as String?;
      final userId = update['userId']?.toString();
      final groupId = update['groupId']?.toString() ?? update['conversationId']?.toString().replaceFirst('group_', '');
      final data = update['data'] as List?;

      if (table == 'group_members' && userId != null && groupId != null && data != null) {
        for (final item in data) {
          final version = item['version'] as int?;
          if (version != null) {
            await _groupMemberBusiness.handleTableUpdates(userId, groupId, version);
          }
        }
      }
    }
  }
}

final groupMemberReceiver = GroupMemberReceiver();
