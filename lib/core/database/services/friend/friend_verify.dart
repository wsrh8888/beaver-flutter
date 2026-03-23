import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class FriendVerifyService extends BaseService {
  FriendVerifyService(super.db);

  /// 根据验证记录ID批量查询好友验证记录
  Future<Map<String, FriendVerify>> getFriendVerifiesByIds(List<String> verifyIds) async {
    if (verifyIds.isEmpty) {
      return {};
    }

    final existingVerifies = await (db.select(db.friendVerifies)..where((t) => t.verifyId.isIn(verifyIds))).get();

    final verifyMap = <String, FriendVerify>{};
    for (final verify in existingVerifies) {
      verifyMap[verify.verifyId] = verify;
    }

    return verifyMap;
  }

  /// 批量创建好友验证记录（支持插入或更新）
  Future<void> batchCreate(List<FriendVerifiesCompanion> verifies) async {
    if (verifies.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final verify in verifies) {
        batch.insert(
          db.friendVerifies,
          verify,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 获取好友验证列表
  Future<List<FriendVerify>> getValidList(String userId, {int page = 1, int limit = 20}) async {
    final offset = (page - 1) * limit;

    // 查询发送给当前用户的验证记录或当前用户发送的验证记录
    var query = db.select(db.friendVerifies)
          ..where((t) => t.revUserId.equals(userId) | t.sendUserId.equals(userId))
          ..limit(limit, offset: offset);
    
    return query.get();
  }

  /// 根据版本范围获取验证列表
  Future<List<FriendVerify>> getValidByVerRange(String userId, {int startVersion = 0, int endVersion = 9223372036854775807}) async {
    // 查询指定版本范围内的验证记录
    return (db.select(db.friendVerifies)
          ..where((t) =>
              (t.revUserId.equals(userId) | t.sendUserId.equals(userId)) &
              t.version.isBiggerOrEqualValue(startVersion) &
              t.version.isSmallerOrEqualValue(endVersion)))
        .get();
  }

  /// 根据验证记录ID列表批量查询验证记录
  Future<List<FriendVerify>> getValidByIds(List<String> verifyIds) async {
    if (verifyIds.isEmpty) {
      return [];
    }

    return (db.select(db.friendVerifies)..where((t) => t.verifyId.isIn(verifyIds))).get();
  }

  /// 获取未读（待处理）申请数
  Future<int> getUnreadCount(String userId) async {
    final query = db.selectOnly(db.friendVerifies)
      ..addColumns([db.friendVerifies.id.count()])
      ..where(db.friendVerifies.revUserId.equals(userId) & db.friendVerifies.revStatus.equals(0));
    final result = await query.map((row) => row.read<int>(db.friendVerifies.id.count())).getSingle();
    return result ?? 0;
  }
}
