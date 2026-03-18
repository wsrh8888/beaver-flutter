import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';

// 表情包与表情关联服务
class EmojiPackageEmojiService extends BaseService {
  EmojiPackageEmojiService(AppDatabase db) : super(db);

  /**
   * @description 创建表情包与表情关联
   */
  Future<void> create(Map<String, dynamic> req) async {
    await db
        .into(db.emojiPackageEmojiTable)
        .insert(
          EmojiPackageEmojiTableCompanion(
            relationId: Value(req['relationId']),
            packageId: Value(req['packageId']),
            emojiId: Value(req['emojiId']),
            sortOrder: Value(req['sortOrder'] ?? 0),
            version: Value(req['version'] ?? 0),
            createdAt: Value(
              req['createdAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
            ),
            updatedAt: Value(
              req['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
            ),
          ),
        );
  }

  /**
   * @description 批量创建表情包与表情关联（upsert操作）
   */
  Future<void> batchCreate(Map<String, dynamic> req) async {
    final relations = req['relations'] as List<dynamic>;
    if (relations.isEmpty) {
      return;
    }

    for (final relationData in relations) {
      await db
          .into(db.emojiPackageEmojiTable)
          .insert(
            EmojiPackageEmojiTableCompanion(
              relationId: Value(relationData['relationId']),
              packageId: Value(relationData['packageId']),
              emojiId: Value(relationData['emojiId']),
              sortOrder: Value(relationData['sortOrder'] ?? 0),
              version: Value(relationData['version'] ?? 0),
              createdAt: Value(
                relationData['createdAt'] ??
                    DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
              updatedAt: Value(
                relationData['updatedAt'] ??
                    DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  /**
   * @description 根据表情包ID获取表情列表
   */
  Future<List<dynamic>> getEmojisByPackageId(Map<String, dynamic> req) async {
    final packageId = req['packageId'] as String;
    final result =
        await (db.select(db.emojiPackageEmojiTable)
              ..where((t) => t.packageId.equals(packageId))
              ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
            .get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 根据表情ID获取表情包列表
   */
  Future<List<dynamic>> getPackagesByEmojiId(Map<String, dynamic> req) async {
    final emojiId = req['emojiId'] as String;
    final result = await (db.select(
      db.emojiPackageEmojiTable,
    )..where((t) => t.emojiId.equals(emojiId))).get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 删除表情包与表情关联
   */
  Future<void> delete(Map<String, dynamic> req) async {
    final relationId = req['relationId'] as String;
    await (db.delete(
      db.emojiPackageEmojiTable,
    )..where((t) => t.relationId.equals(relationId))).go();
  }
}
