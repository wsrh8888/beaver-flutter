import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/di/injection.dart';

/// Handles friends table updates.
class FriendReceiver {
  Future<void> handleTableUpdates(Map<String, dynamic> tableUpdatesBody) async {
    final tableUpdates =
        (tableUpdatesBody['tableUpdates'] ?? tableUpdatesBody['tables'])
            as List?;
    if (tableUpdates == null) return;

    final Map<String, int> latestVersionByFriendId = {};
    final friendUpdates = tableUpdates
        .where((update) => update['table'] == 'friends')
        .toList();

    for (final update in friendUpdates) {
      final data = update['data'] as List?;
      if (data == null) continue;

      for (final dataItem in data) {
        final version = dataItem['version'] as int? ?? 0;
        final friendId = dataItem['friendId'] as String?;
        if (friendId == null || friendId.trim().isEmpty) continue;

        final oldVersion = latestVersionByFriendId[friendId] ?? 0;
        if (version > oldVersion) {
          latestVersionByFriendId[friendId] = version;
        }
      }
    }

    for (final item in latestVersionByFriendId.entries) {
      await getIt<FriendBusiness>().handleTableUpdates(item.value, item.key);
    }
  }
}

final friendReceiver = FriendReceiver();
