import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';

// 表情包服务
class EmojiPackageService extends BaseService {
  EmojiPackageService(AppDatabase db) : super(db);

  /**
   * @description 创建表情包
   */
  Future<void> create(Map<String, dynamic> req) async {
    await db
        .into(db.emojiPackageTable)
        .insert(
          EmojiPackageTableCompanion(
            packageId: Value(req['packageId']),
            title: Value(req['title']),
            coverFile: Value(req['coverFile']),
            userId: Value(req['userId']),
            description: Value(req['description']),
            type: Value(req['type']),
            status: Value(req['status'] ?? 1),
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
   * @description 批量创建表情包（upsert操作）
   */
  Future<void> batchCreate(Map<String, dynamic> req) async {
    final packageList = req['packageList'] as List<dynamic>;
    if (packageList.isEmpty) {
      return;
    }

    for (final packageData in packageList) {
      await db
          .into(db.emojiPackageTable)
          .insert(
            EmojiPackageTableCompanion(
              packageId: Value(packageData['packageId']),
              title: Value(packageData['title']),
              coverFile: Value(packageData['coverFile']),
              userId: Value(packageData['userId']),
              description: Value(packageData['description']),
              type: Value(packageData['type']),
              status: Value(packageData['status'] ?? 1),
              version: Value(packageData['version'] ?? 0),
              createdAt: Value(
                packageData['createdAt'] ??
                    DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
              updatedAt: Value(
                packageData['updatedAt'] ??
                    DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  /**
   * @description 根据ID列表获取表情包
   */
  Future<Map<String, dynamic>> getPackagesByIds(
    Map<String, dynamic> req,
  ) async {
    final ids = req['ids'] as List<String>;
    if (ids.isEmpty) {
      return {};
    }

    final packageList = await (db.select(
      db.emojiPackageTable,
    )..where((t) => t.packageId.isIn(ids))).get();

    final packages = <String, dynamic>{};
    for (final item in packageList) {
      packages[item.packageId] = item.toJson();
    }

    return packages;
  }

  /**
   * @description 根据用户ID获取用户创建的表情包
   */
  Future<List<dynamic>> getPackagesByUserId(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final result = await (db.select(
      db.emojiPackageTable,
    )..where((t) => t.userId.equals(userId))).get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 获取所有表情包
   */
  Future<List<dynamic>> getAllPackages(Map<String, dynamic> req) async {
    final result = await db.select(db.emojiPackageTable).get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 根据ID获取单个表情包
   */
  Future<dynamic> getPackageById(Map<String, dynamic> req) async {
    final id = req['id'] as String;
    final result = await (db.select(
      db.emojiPackageTable,
    )..where((t) => t.packageId.equals(id))).get();
    return result.isNotEmpty ? result.first.toJson() : null;
  }

  /**
   * @description 根据内部自增ID查询
   */
  Future<dynamic> getPackageByAutoId(Map<String, dynamic> req) async {
    final id = req['id'] as int;
    final result = await (db.select(
      db.emojiPackageTable,
    )..where((t) => t.id.equals(id))).get();
    return result.isNotEmpty ? result.first.toJson() : null;
  }
}
