import 'package:drift/drift.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/user.dart';
import 'package:beaver/core/database/app_database.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/user.dart' as user_types;

/// 用户同步（两阶段增量同步）
class UserSync {
  Future<void> checkAndSync() async {
    print('[UserSync] 开始同步用户数据');

    final datasyncService = getIt<DatasyncService>();
    final userService = getIt<UserService>();

    // 1. 获取本地同步最后时间
    final cursor = await datasyncService.get('users');
    final lastSyncTime = cursor?.version ?? 0;

    // 2. 获取变更的用户版本摘要
    final response = await datasyncGetSyncAllUsersApi(IGetSyncAllUsersReq(
      type: 'all',
      since: lastSyncTime,
    ));

    if (response.code != 0 || response.result == null) {
      print('[UserSync] 获取用户同步列表失败: ${response.msg}');
      return;
    }

    final changedUserVersions = response.result!.userVersions;
    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比本地数据，过滤出需要更新的用户
    final needUpdateUsers = await _compareAndFilterUserVersions(userService, changedUserVersions);

    if (needUpdateUsers.isNotEmpty) {
      // 4. 同步具体用户数据
      await _syncUserData(userService, needUpdateUsers);
      
      // 5. 更新游标
      final maxVersion = changedUserVersions.map((e) => e.version).reduce((a, b) => a > b ? a : b);
      await datasyncService.upsert('users', maxVersion, serverTimestamp);
    } else {
      // 没有更新
      await datasyncService.upsert('users', null, serverTimestamp);
    }

    print('[UserSync] 用户数据同步完成');
  }

  Future<List<user_types.IUserVersionItem>> _compareAndFilterUserVersions(
    UserService userService,
    List<IUserVersionItem> serverVersions,
  ) async {
    if (serverVersions.isEmpty) return [];

    final localStatuses = await userService.getAllUsersSyncStatus();
    final localVersionMap = {for (var s in localStatuses) s.userId: s.userVersion};

    final List<user_types.IUserVersionItem> needUpdate = [];
    for (final sv in serverVersions) {
      final localVersion = localVersionMap[sv.userId] ?? 0;
      if (localVersion < sv.version) {
        // 使用本地版本号请求，以便服务器返回增量
        needUpdate.add(user_types.IUserVersionItem(userId: sv.userId, version: localVersion));
      }
    }
    return needUpdate;
  }

  Future<void> _syncUserData(UserService userService, List<user_types.IUserVersionItem> usersWithVersions) async {
    if (usersWithVersions.isEmpty) return;

    final response = await userSyncApi(user_types.IUserSyncReq(userVersions: usersWithVersions));
    if (response.code == 0 && response.result != null) {
      final users = response.result!.users;
      await userService.batchCreate(users);

      // 更新同步状态表
      final statusUpdates = users.map((u) => UserSyncStatusCompanion(
        userId: Value(u.userId),
        userVersion: Value(u.version),
      )).toList();
      await userService.batchUpsertUserSyncStatus(statusUpdates);
      
      // TODO: 发送通知通知 UI
    }
  }
}

final userSync = UserSync();