import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';

class MediaService extends BaseService {
  MediaService(AppDatabase db) : super(db);

  Future<void> upsert(Map<String, dynamic> req) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await db.into(db.mediaTable).insert(
      MediaTableCompanion(
        url: Value(req['url'] as String),
        md5: req.containsKey('md5') ? Value(req['md5'] as String?) : const Value.absent(),
        path: Value(req['path'] as String),
        type: Value(req['type'] as String),
        size: req.containsKey('size') ? Value(req['size'] as int?) : const Value.absent(),
        createdAt: Value(req['createdAt'] ?? now),
        updatedAt: Value(req['updatedAt'] ?? now),
        isDeleted: Value(req['isDeleted'] ?? 0),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<Map<String, dynamic>?> getMediaByUrl(String url) async {
    final result = await (db.select(db.mediaTable)..where((t) => t.url.equals(url))).get();
    if (result.isEmpty) return null;
    return result.first.toJson();
  }

  Future<void> deleteByUrl(String url) async {
    await (db.delete(db.mediaTable)..where((t) => t.url.equals(url))).go();
  }
}
