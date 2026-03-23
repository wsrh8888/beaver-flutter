import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/group.dart';

class GroupJoinRequestService extends BaseService {
  GroupJoinRequestService(super.db);

  /// 批量创建入群申请
  Future<void> batchCreate(List<IGroupJoinRequestSyncItem> requests) async {
    await db.batch((batch) {
      for (final req in requests) {
        batch.insert(
          db.groupJoinRequests,
          GroupJoinRequestsCompanion(
            id: Value(req.id), // id is already int in IGroupJoinRequestSyncItem
            groupId: Value(req.groupId),
            applicantUserId: Value(req.applicantUserId),
            message: Value(req.message),
            status: Value(req.status),
            version: Value(req.version),
            createdAt: Value(req.createdAt),
            updatedAt: Value(req.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 获取未读（待处理）申请数
  Future<int> getUnreadCount() async {
    // 这里简单处理：所有由于我是管理员/创建者而收到的待处理申请
    // 实际业务可能更复杂，这里先根据 status == 0 统计
    final query = db.selectOnly(db.groupJoinRequests)
      ..addColumns([db.groupJoinRequests.id.count()])
      ..where(db.groupJoinRequests.status.equals(0));
    final result = await query.map((row) => row.read<int>(db.groupJoinRequests.id.count())).getSingle();
    return result ?? 0;
  }

  /// 获取所有入群申请
  Future<List<GroupJoinRequest>> getAllRequests() async {
    return await db.select(db.groupJoinRequests).get();
  }
}
