import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/user.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/user.dart';
import 'package:beaver/shared/utils/storage_util.dart';

/// 用户数据同步模块（两阶段增量同步）
class UserSyncModule {
  String _syncStatus = 'PENDING';

  /// 检查并同步用户数据
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) return;

    try {
      final datasyncService = getIt<DatasyncService>();
      final userService = getIt<UserService>();
      final userSyncStatusService = getIt<UserSyncStatusService>();

      // 获取本地最后同步时间
      final cursor = await datasyncService.get('users');
      final lastSyncTime = cursor?.version ?? 0;

      // 获取变更的用户版本摘要
      final response = await datasyncGetSyncAllUsersApi(
        IGetSyncAllUsersReq(type: 'all', since: lastSyncTime),
      );

      if (response.code != 0 || response.result == null) {
        return;
      }

      final changedUserVersions = response.result!.userVersions;
      final serverTimestamp = response.result!.serverTimestamp;

      // 对比本地数据，过滤出需要更新的用户
      final needUpdateUsers = await _compareAndFilterUserVersions(
        userSyncStatusService,
        changedUserVersions,
      );

      if (needUpdateUsers.isNotEmpty) {
        // 有需要更新的用户数据
        await _syncUserData(
          userService,
          userSyncStatusService,
          needUpdateUsers,
        );

        // 从变更的数据中找到最大的版本号
        int maxVersion = 0;
        for (var item in changedUserVersions) {
          if (item.version > maxVersion) maxVersion = item.version;
        }

        await datasyncService.upsert('users', maxVersion, serverTimestamp);
      } else {
        // 没有需要更新的数据，直接更新时间戳
        await datasyncService.upsert('users', null, serverTimestamp);
      }

      _syncStatus = 'COMPLETED';
    } catch (error) {
      _syncStatus = 'FAILED';
    }
  }

  /// 对比本地数据，过滤出需要更新的用户
  Future<List<IUserVersionItem>> _compareAndFilterUserVersions(
    UserSyncStatusService userSyncStatusService,
    List<IUserVersionItem> userVersions,
  ) async {
    if (userVersions.isEmpty) return [];

    // 获取所有本地用户同步状态
    final localStatuses = await userSyncStatusService.getAllUsersSyncStatus();
    final localVersionMap = {
      for (var s in localStatuses) s.userId: s.userVersion,
    };

    // 过滤出需要更新的用户，并使用本地版本号
    final List<IUserVersionItem> needUpdateUsers = [];
    for (var userVersion in userVersions) {
      final localVersion = localVersionMap[userVersion.userId] ?? 0;
      if (localVersion < userVersion.version) {
        needUpdateUsers.add(
          IUserVersionItem(
            userId: userVersion.userId,
            version: localVersion, // 使用本地版本号
          ),
        );
      }
    }

    return needUpdateUsers;
  }

  /// 同步用户数据
  Future<void> _syncUserData(
    UserService userService,
    UserSyncStatusService userSyncStatusService,
    List<IUserVersionItem> usersWithVersions,
  ) async {
    if (usersWithVersions.isEmpty) return;

    // 直接使用传入的用户版本信息构造请求
    final syncResponse = await userSyncApi(
      IUserSyncReq(userVersions: usersWithVersions),
    );
    if (syncResponse.code == 0 &&
        syncResponse.result != null &&
        syncResponse.result!.users.isNotEmpty) {
      await userService.batchCreate(syncResponse.result!.users);

      // 更新本地用户版本状态
      final statusUpdates = syncResponse.result!.users
          .map((user) => {'userId': user.userId, 'userVersion': user.version})
          .toList();
      await userSyncStatusService.batchUpsertUserSyncStatus(statusUpdates);

      // TODO: 发送通知到渲染进程
    }
  }

  String getStatus() => _syncStatus;
}

final userSyncModule = UserSyncModule();
