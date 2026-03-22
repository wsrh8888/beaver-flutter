import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/business/friend/friend_verify.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/di/injection.dart';

/**
 * 好友验证接收器 - 处理 friend_verify 表的操作
 * 对标 PC receivers/friend/friend-verify-receiver.ts
 */
class FriendVerifyReceiver {
  /**
   * 处理好友验证表更新通知
   * 处理 friend_verify 表、friends 表和 users 表的更新
   */
  Future<void> handleTableUpdates(Map<String, dynamic> tableUpdatesBody) async {
    final tableUpdates = tableUpdatesBody['tableUpdates'] as List?;
    if (tableUpdates == null) return;

    // 1. 处理好友验证更新 (friend_verify)
    final verifyUpdates = tableUpdates.where((update) => update['table'] == 'friend_verify').toList();
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

    // 2. 处理好友关系更新 (friends)
    final friendUpdates = tableUpdates.where((update) => update['table'] == 'friends').toList();
    for (final update in friendUpdates) {
      final data = update['data'] as List?;
      if (data == null) continue;
      for (final dataItem in data) {
        await getIt<FriendBusiness>().handleTableUpdates(
          dataItem['version'] as int? ?? 0,
          dataItem['friendId'] as String?,
        );
      }
    }

    // 3. 处理用户更新 (users)
    final userUpdates = tableUpdates.where((update) => update['table'] == 'users').toList();
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
