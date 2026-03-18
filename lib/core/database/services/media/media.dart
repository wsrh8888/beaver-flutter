import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';

// 媒体服务
class MediaService extends BaseService {
  MediaService(AppDatabase db) : super(db);

  /**
   * @description 创建媒体记录
   */
  Future<void> create(Map<String, dynamic> req) async {
    await db.into(db.mediaTable).insert(MediaTableCompanion(
      fileKey: Value(req['fileKey']),
      path: Value(req['path']),
      type: Value(req['type']),
      size: Value(req['size']),
      createdAt: Value(req['createdAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
      updatedAt: Value(req['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
      isDeleted: Value(req['isDeleted'] ?? 0),
    ));
  }

  /**
   * @description 批量创建媒体记录（upsert操作）
   */
  Future<void> batchCreate(Map<String, dynamic> req) async {
    final mediaList = req['mediaList'] as List<dynamic>;
    if (mediaList.isEmpty) {
      return;
    }

    for (final mediaData in mediaList) {
      await db.into(db.mediaTable).insert(
        MediaTableCompanion(
          fileKey: Value(mediaData['fileKey']),
          path: Value(mediaData['path']),
          type: Value(mediaData['type']),
          size: Value(mediaData['size']),
          createdAt: Value(mediaData['createdAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
          updatedAt: Value(mediaData['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
          isDeleted: Value(mediaData['isDeleted'] ?? 0),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  /**
   * @description 根据文件键获取媒体记录
   */
  Future<dynamic> getMediaByFileKey(Map<String, dynamic> req) async {
    final fileKey = req['fileKey'] as String;
    final result = await (db.select(db.mediaTable)..where((t) => t.fileKey.equals(fileKey))).get();
    return result.isNotEmpty ? result.first.toJson() : null;
  }

  /**
   * @description 根据类型获取媒体记录列表
   */
  Future<List<dynamic>> getMediaByType(Map<String, dynamic> req) async {
    final type = req['type'] as String;
    final result = await (db.select(db.mediaTable)..where((t) => t.type.equals(type))).get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 更新媒体记录
   */
  Future<void> update(Map<String, dynamic> req) async {
    final fileKey = req['fileKey'] as String;

    await (db.update(db.mediaTable)
      ..where((t) => t.fileKey.equals(fileKey)))
      .write(MediaTableCompanion(
        path: req.containsKey('path') ? Value(req['path']) : const Value.absent(),
        type: req.containsKey('type') ? Value(req['type']) : const Value.absent(),
        size: req.containsKey('size') ? Value(req['size']) : const Value.absent(),
        isDeleted: req.containsKey('isDeleted') ? Value(req['isDeleted']) : const Value.absent(),
        updatedAt: Value(req['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
      ));
  }

  /**
   * @description 删除媒体记录
   */
  Future<void> delete(Map<String, dynamic> req) async {
    final fileKey = req['fileKey'] as String;
    await (db.delete(db.mediaTable)..where((t) => t.fileKey.equals(fileKey))).go();
  }
}
