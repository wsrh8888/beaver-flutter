import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/circle.dart';

class CircleService extends BaseService {
  const CircleService();

  /// 创建或更新圈子
  Future<void> upsert(CirclesCompanion circle) async {
    await db.into(db.circles).insert(
          circle,
          mode: InsertMode.insertOrReplace,
        );
  }

  /// 批量插入或更新（基于版本号判断是否需要更新）
  Future<void> batchUpsert(List<ICircleSyncItem> items) async {
    if (items.isEmpty) {
      return;
    }

    for (final item in items) {
      final local = await getCircleById(item.circleId);
      if (local == null || local.version != item.version) {
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        await upsert(
          CirclesCompanion(
            circleId: Value(item.circleId),
            name: Value(item.name),
            avatar: Value(item.avatar),
            description: Value(local?.description ?? ''),
            creatorId: Value(local?.creatorId ?? ''),
            memberCount: Value(item.memberCount),
            role: Value(item.role),
            joinType: Value(local?.joinType ?? 0),
            version: Value(item.version),
            createdAt: local?.createdAt != null
                ? Value(local!.createdAt!)
                : Value(now),
            updatedAt: Value(now),
          ),
        );
      }
    }
  }

  /// 根据圈子 ID 获取
  Future<Circle?> getCircleById(String circleId) async {
    return (db.select(db.circles)..where((t) => t.circleId.equals(circleId)))
        .getSingleOrNull();
  }

  /// 根据 ID 列表批量获取
  Future<List<Circle>> getCirclesByIds(List<String> circleIds) async {
    if (circleIds.isEmpty) {
      return [];
    }
    return (db.select(db.circles)..where((t) => t.circleId.isIn(circleIds)))
        .get();
  }

  /// 当前用户仍在圈内的列表（role > 0）
  Future<List<Circle>> getActiveCircles() async {
    return (db.select(db.circles)
          ..where((t) => t.role.isBiggerThanValue(0))
          ..orderBy([
            (t) => OrderingTerm.desc(t.updatedAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
  }

  /// 获取全部圈子
  Future<List<Circle>> getCircleList() async {
    return (db.select(db.circles)
          ..orderBy([
            (t) => OrderingTerm.desc(t.updatedAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
  }

  /// 删除圈子
  Future<void> deleteCircle(String circleId) async {
    await (db.delete(db.circles)..where((t) => t.circleId.equals(circleId)))
        .go();
  }
}
