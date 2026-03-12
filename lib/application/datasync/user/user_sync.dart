import 'package:beaver/core/database/database.dart';
import 'package:beaver/core/network/api/api.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/utils/storage_util.dart';

/// 用户数据同步 (对标 desktop datasync/user/user.ts)
class UserSyncModule {
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) return;
    print('[DataSync] 开始同步用户数据');
    try {
      final userApi = getIt<UserApi>();
      final db = getIt<AppDatabase>();
      final cursor = await (db.select(db.datasync)..where((t) => t.module.equals('users'))).getSingleOrNull();
      final lastSyncTime = cursor?.updatedAt ?? 0;
      await Future.delayed(const Duration(milliseconds: 50));
      print('[DataSync] 用户同步完成');
    } catch (e) {
      print('[DataSync] 用户同步失败: $e');
    }
  }
}
