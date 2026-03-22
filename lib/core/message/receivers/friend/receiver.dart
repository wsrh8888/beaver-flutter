import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/di/injection.dart';

/**
 * 好友操作接收器 - 处理 friends 表的操作
 * 对标 PC receivers/friend/receiver.ts
 */
class FriendReceiver {
  /**
   * 处理好友表更新通知
   * 只处理 friends 表的更新
   */
  Future<void> handleTableUpdates(Map<String, dynamic> tableUpdatesBody) async {
    final tableUpdates = tableUpdatesBody['tableUpdates'] as List?;
    if (tableUpdates == null) return;

    // 过滤出只包含 friends 的更新
    final friendUpdates = tableUpdates.where((update) => update['table'] == 'friends').toList();

    for (final update in friendUpdates) {
      final data = update['data'] as List?;
      if (data == null) continue;

      for (final dataItem in data) {
        final version = dataItem['version'] as int? ?? 0;
        final friendId = dataItem['friendId'] as String?;
        await getIt<FriendBusiness>().handleTableUpdates(version, friendId);
      }
    }
  }
}

final friendReceiver = FriendReceiver();
