import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/friend.dart';

class FriendService extends BaseService {
  FriendService(super.db);

  /// 根据 IDs 获取好友记录
  Future<List<Friend>> getFriendRecordsByIds(List<String> friendshipIds) async {
    return (db.select(db.friends)..where((t) => t.friendId.isIn(friendshipIds))).get();
  }

  /// 根据 IDs 获取验证记录
  Future<List<FriendVerify>> getFriendVerifiesByIds(List<String> verifyIds) async {
    return (db.select(db.friendVerifies)..where((t) => t.verifyId.isIn(verifyIds))).get();
  }

  /// 批量创建或更新好友
  Future<void> batchCreate(List<IFriendSyncItem> friends) async {
    await db.batch((batch) {
      for (final friend in friends) {
        batch.insert(
          db.friends,
          FriendsCompanion(
            friendId: Value(friend.friendId),
            sendUserId: Value(friend.sendUserId),
            revUserId: Value(friend.revUserId),
            sendUserNotice: Value(friend.sendUserNotice),
            revUserNotice: Value(friend.revUserNotice),
            source: Value(friend.source),
            isDeleted: Value(friend.isDeleted ? 1 : 0),
            version: Value(friend.version),
            createdAt: Value(friend.createdAt),
            updatedAt: Value(friend.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 批量创建或更新好友验证
  Future<void> batchCreateVerifies(List<IFriendVerifySyncItem> verifies) async {
    await db.batch((batch) {
      for (final verify in verifies) {
        batch.insert(
          db.friendVerifies,
          FriendVerifiesCompanion(
            verifyId: Value(verify.verifyId),
            sendUserId: Value(verify.sendUserId),
            revUserId: Value(verify.revUserId),
            sendStatus: Value(verify.sendStatus),
            revStatus: Value(verify.revStatus),
            message: Value(verify.message),
            source: Value(verify.source),
            version: Value(verify.version),
            createdAt: Value(verify.createdAt),
            updatedAt: Value(verify.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}
