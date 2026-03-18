import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';

// 表情包收藏服务
class EmojiPackageCollectService extends BaseService {
  EmojiPackageCollectService(AppDatabase db) : super(db);

  /**
   * @description 创建表情包收藏
   */
  Future<void> create(Map<String, dynamic> req) async {
    await db
        .into(db.emojiPackageCollectTable)
        .insert(
          EmojiPackageCollectTableCompanion(
            packageCollectId: Value(req['packageCollectId']),
            userId: Value(req['userId']),
            packageId: Value(req['packageId']),
            isDeleted: Value(req['isDeleted'] ?? 0),
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
   * @description 批量创建表情包收藏（upsert操作）
   */
  Future<void> batchCreate(Map<String, dynamic> req) async {
    final collects = req['collects'] as List<dynamic>;
    if (collects.isEmpty) {
      return;
    }

    for (final collectData in collects) {
      await db
          .into(db.emojiPackageCollectTable)
          .insert(
            EmojiPackageCollectTableCompanion(
              packageCollectId: Value(collectData['packageCollectId']),
              userId: Value(collectData['userId']),
              packageId: Value(collectData['packageId']),
              isDeleted: Value(collectData['isDeleted'] ?? 0),
              version: Value(collectData['version'] ?? 0),
              createdAt: Value(
                collectData['createdAt'] ??
                    DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
              updatedAt: Value(
                collectData['updatedAt'] ??
                    DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  /**
   * @description 根据用户ID获取用户的所有表情包收藏
   */
  Future<List<dynamic>> getCollectsByUserId(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final result = await (db.select(
      db.emojiPackageCollectTable,
    )..where((t) => t.userId.equals(userId))).get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 根据ID获取单个表情包收藏
   */
  Future<dynamic> getCollectById(Map<String, dynamic> req) async {
    final id = req['id'] as String;
    final result = await (db.select(
      db.emojiPackageCollectTable,
    )..where((t) => t.packageCollectId.equals(id))).get();
    return result.isNotEmpty ? result.first.toJson() : null;
  }

  /**
   * @description 删除表情包收藏
   */
  Future<void> delete(Map<String, dynamic> req) async {
    final id = req['id'] as String;
    await (db.delete(
      db.emojiPackageCollectTable,
    )..where((t) => t.packageCollectId.equals(id))).go();
  }
}
