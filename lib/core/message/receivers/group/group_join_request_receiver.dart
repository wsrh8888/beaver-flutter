import 'package:beaver/core/business/group/group_join_request.dart';
import 'package:beaver/di/injection.dart';

/// 群加入请求接收器 - 处理 group_join_requests 表的操作 (对标 PC receivers/group/group-join-request-receiver.ts)
class GroupJoinRequestReceiver {
  GroupJoinRequestBusiness get _groupJoinRequestBusiness => getIt<GroupJoinRequestBusiness>();

  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final updates = (body['tables'] ?? body['tableUpdates']) as List?;
    if (updates == null) return;

    for (final update in updates) {
      final table = update['table'] as String?;
      final userId = update['userId']?.toString();
      final groupId = update['groupId']?.toString() ?? update['conversationId']?.toString().replaceFirst('group_', '');
      final data = update['data'] as List?;

      if (table == 'group_join_requests' && userId != null && groupId != null && data != null) {
        for (final item in data) {
          final version = item['version'] as int?;
          if (version != null) {
            await _groupJoinRequestBusiness.handleTableUpdates(userId, groupId, version);
          }
        }
      }
    }
  }
}

final groupJoinRequestReceiver = GroupJoinRequestReceiver();
