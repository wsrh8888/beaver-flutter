import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class FriendService extends BaseService {
  const FriendService();

  /// 根据 IDs 获取好友记录
  Future<List<Friend>> getFriendRecordsByIds(List<String> friendshipIds) async {
    return (db.select(
      db.friends,
    )..where((t) => t.friendId.isIn(friendshipIds))).get();
  }

  /// 获取两个用户之间的好友关系
  Future<Friend?> getFriendByPeerId(String currentUserId, String peerId) async {
    final friends = await (db.select(db.friends)..where(
          (t) =>
              t.isDeleted.equals(0) &
              ((t.sendUserId.equals(currentUserId) &
                      t.revUserId.equals(peerId)) |
                  (t.sendUserId.equals(peerId) &
                      t.revUserId.equals(currentUserId))),
        ))
        .get();
    return friends.isNotEmpty ? friends.first : null;
  }

  /// 获取所有好友列表
  Future<List<Friend>> getFriends() async {
    return (db.select(db.friends)..where((t) => t.isDeleted.equals(0))).get();
  }

  /// 删除好友 (本地标识删除)
  Future<void> deleteFriend(String friendId) async {
    await (db.update(db.friends)..where((t) => t.friendId.equals(friendId)))
        .write(const FriendsCompanion(isDeleted: Value(1)));
  }

  /// 根据 IDs 获取验证记录
  Future<List<FriendVerify>> getFriendVerifiesByIds(
    List<String> verifyIds,
  ) async {
    return (db.select(
      db.friendVerifies,
    )..where((t) => t.verifyId.isIn(verifyIds))).get();
  }

  /// 批量创建或更新好友
  Future<void> batchCreate(List<FriendsCompanion> friends) async {
    await db.batch((batch) {
      for (final companion in friends) {
        batch.insert(db.friends, companion, mode: InsertMode.insertOrReplace);
      }
    });
  }

  /// 批量创建或更新好友验证
  Future<void> batchCreateVerifies(
    List<FriendVerifiesCompanion> verifies,
  ) async {
    await db.batch((batch) {
      for (final companion in verifies) {
        batch.insert(
          db.friendVerifies,
          companion,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 更新好友备注
  Future<void> updateNotice(
    String friendId, {
    String? sendUserNotice,
    String? revUserNotice,
  }) async {
    await (db.update(db.friends)..where((t) => t.friendId.equals(friendId)))
        .write(
      FriendsCompanion(
        sendUserNotice: sendUserNotice != null
            ? Value(sendUserNotice)
            : const Value.absent(),
        revUserNotice: revUserNotice != null
            ? Value(revUserNotice)
            : const Value.absent(),
      ),
    );
  }
}
