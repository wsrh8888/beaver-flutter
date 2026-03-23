import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/business/friend/friend_verify.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/di/injection.dart';

/// Handles friend_verify, friends and users updates in friend verify channel.
class FriendVerifyReceiver {
  Future<void> handleTableUpdates(Map<String, dynamic> tableUpdatesBody) async {
    final tableUpdates =
        (tableUpdatesBody['tableUpdates'] ?? tableUpdatesBody['tables'])
            as List?;
    if (tableUpdates == null) return;

    final verifyUpdates = tableUpdates
        .where((update) => update['table'] == 'friend_verify')
        .toList();
    for (final update in verifyUpdates) {
      final data = update['data'] as List?;
      if (data == null) continue;
      for (final dataItem in data) {
        await getIt<FriendVerifyBusiness>().handleTableUpdates(
          dataItem['userId'] as String?,
          dataItem['verifyId'] as int?,
          dataItem['version'] as int? ?? 0,
        );
      }
    }

    final Map<String, int> latestVersionByFriendId = {};
    final friendUpdates =
        tableUpdates.where((update) => update['table'] == 'friends').toList();
    for (final update in friendUpdates) {
      final data = update['data'] as List?;
      if (data == null) continue;
      for (final dataItem in data) {
        final friendId = dataItem['friendId'] as String?;
        final version = dataItem['version'] as int? ?? 0;
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

    final userUpdates =
        tableUpdates.where((update) => update['table'] == 'users').toList();
    for (final update in userUpdates) {
      final data = update['data'] as List?;
      if (data == null) continue;
      for (final dataItem in data) {
        await getIt<UserBusiness>().handleTableUpdates(
          dataItem['userId'] as String? ?? '',
          dataItem['version'] as int? ?? 0,
        );
      }
    }
  }
}

final friendVerifyReceiver = FriendVerifyReceiver();
