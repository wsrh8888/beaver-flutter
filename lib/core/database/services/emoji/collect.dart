import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';
import 'package:beaver/core/database/tables/emoji/collect.dart';

// 表情收藏服务
class EmojiCollectService extends BaseService {
  EmojiCollectService(AppDatabase db) : super(db);

  /**
   * @description 创建表情收藏
   */
  Future<void> create(Map<String, dynamic> req) async {
    await db.into(db.emojiCollectTable).insert(EmojiCollectTableCompanion(
      emojiCollectId: Value(req['emojiCollectId']),
      userId: Value(req['userId']),
      emojiId: Value(req['emojiId']),
      packageId: Value(req['packageId']),
      isDeleted: Value(req['isDeleted'] ?? 0),
      version: Value(req['version'] ?? 0),
      createdAt: Value(req['createdAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
      updatedAt: Value(req['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
    ));
  }

  /**
   * @description 批量创建表情收藏（upsert操作）
   */
  Future<void> batchCreate(Map<String, dynamic> req) async {
    final collects = req['collects'] as List<dynamic>;
    if (collects.isEmpty) {
      return;
    }

    for (final collectData in collects) {
      await db.into(db.emojiCollectTable).insert(
        EmojiCollectTableCompanion(
          emojiCollectId: Value(collectData['emojiCollectId']),
          userId: Value(collectData['userId']),
          emojiId: Value(collectData['emojiId']),
          packageId: Value(collectData['packageId']),
          isDeleted: Value(collectData['isDeleted'] ?? 0),
          version: Value(collectData['version'] ?? 0),
          createdAt: Value(collectData['createdAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
          updatedAt: Value(collectData['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  /**
   * @description 根据ID列表获取表情收藏
   */
  Future<Map<String, dynamic>> getCollectsByIds(Map<String, dynamic> req) async {
    final ids = req['ids'] as List<String>;
    if (ids.isEmpty) {
      return {};
    }

    final collectList = await db.select(db.emojiCollectTable).where((t) => t.emojiCollectId.isIn(ids)).get();

    final collectMap = <String, dynamic>{};
    for (final item in collectList) {
      collectMap[item.emojiCollectId] = item.toJson();
    }

    return collectMap;
  }

  /**
   * @description 根据用户ID获取用户的所有表情收藏
   */
  Future<List<dynamic>> getCollectsByUserId(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final result = await db.select(db.emojiCollectTable).where((t) => t.userId.equals(userId)).get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 根据ID获取单个表情收藏
   */
  Future<dynamic> getCollectById(Map<String, dynamic> req) async {
    final id = req['id'] as String;
    final result = await db.select(db.emojiCollectTable).where((t) => t.emojiCollectId.equals(id)).get();
    return result.isNotEmpty ? result.first.toJson() : null;
  }

  /**
   * @description 删除表情收藏
   */
  Future<void> delete(Map<String, dynamic> req) async {
    final id = req['id'] as String;
    await db.delete(db.emojiCollectTable).where((t) => t.emojiCollectId.equals(id)).go();
  }
}
