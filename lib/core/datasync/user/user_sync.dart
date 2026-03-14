import 'package:beaver/core/database/database.dart';
import 'package:beaver/api/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/utils/storage_util.dart';

/// 用户数据同步
class UserSync {
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) return;
    print('[UserSync] 开始同步用户数据');
    try {
      final userApi = getIt<User>();
      final db = getIt<AppDatabase>();
      final cursor = await (db.select(db.datasync)..where((t) => t.module.equals('users'))).getSingleOrNull();
      final lastSyncTime = cursor?.updatedAt ?? 0;
      // TODO: 实现用户同步逻辑
      await Future.delayed(const Duration(milliseconds: 50));
      print('[UserSync] 用户同步完成');
    } catch (e) {
      print('[UserSync] 用户同步失败: $e');
    }
  }
}

final userSync = UserSync();
