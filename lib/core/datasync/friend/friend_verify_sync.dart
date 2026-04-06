import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/friend.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:drift/drift.dart';

/// 好友验证数据同步模块
class FriendVerifySyncModule {
  String _syncStatus = 'PENDING';

  /// 检查并同步
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) return;

    try {
      final datasyncService = getIt<DatasyncService>();
      final friendVerifyService = getIt<FriendVerifyService>();

      // 获取本地同步时间戳
      final localCursor = await datasyncService.get('friend_verifies');
      final lastSyncTime = localCursor?.updatedAt ?? 0;

      // 获取服务器上变更的好友验证版本信息
      final serverResponse = await datasyncGetSyncFriendVerifiesApi(
        IGetSyncFriendVerifiesReq(since: lastSyncTime),
      );
      if (serverResponse.code != 0 || serverResponse.result == null) {
        // print('[FriendVerifySyncModule] 获取好友验证版本失败: ${serverResponse.msg}');
        return;
      }

      final friendVerifyVersions = serverResponse.result!.friendVerifyVersions;
      final serverTimestamp = serverResponse.result!.serverTimestamp;

      // 对比本地数据，过滤出需要更新的数据
      final needUpdateUuids = await _compareAndFilterFriendVerifyVersions(
        friendVerifyService,
        friendVerifyVersions,
      );

      if (needUpdateUuids.isNotEmpty) {
        // 有需要更新的好友验证数据
        await _syncFriendVerifyData(friendVerifyService, needUpdateUuids);

        // 从变更的数据中找到最大的版本号
        int maxVersion = 0;
        for (var item in friendVerifyVersions) {
          if (item.version > maxVersion) maxVersion = item.version;
        }

        await _updateFriendVerifiesCursor(
          datasyncService,
          maxVersion,
          serverTimestamp,
        );
      } else {
        // 没有需要更新的数据，直接更新时间戳
        await _updateFriendVerifiesCursor(
          datasyncService,
          localCursor?.version ?? 0, // 保持原有最高版本号
          serverTimestamp,
        );
      }

      _syncStatus = 'COMPLETED';
    } catch (error) {
      _syncStatus = 'FAILED';
      // print('[FriendVerifySyncModule] 好友验证数据同步失败: $error');
    }
  }

  /// 对比本地数据，过滤出需要更新的好友验证ID
  Future<List<String>> _compareAndFilterFriendVerifyVersions(
    FriendVerifyService friendVerifyService,
    List<IFriendVerifyVersionItem> friendVerifyVersions,
  ) async {
    if (friendVerifyVersions.isEmpty) return [];

    // 提取所有变更的好友验证ID
    final verifyIds = friendVerifyVersions
        .map((item) => item.verifyId)
        .where((id) => id.trim().isNotEmpty)
        .toList();
    if (verifyIds.isEmpty) return [];

    // 查询本地已存在的记录
    final existingVerifiesMap = await friendVerifyService
        .getFriendVerifiesByIds(verifyIds);

    // 过滤出需要更新的 ID
    final List<String> needUpdateVerifyIds = [];
    for (var id in verifyIds) {
      final existingVerify = existingVerifiesMap[id];
      final serverVersion = friendVerifyVersions
          .firstWhere((item) => item.verifyId == id)
          .version;

      if (existingVerify == null || existingVerify.version < serverVersion) {
        needUpdateVerifyIds.add(id);
      }
    }

    return needUpdateVerifyIds;
  }

  /// 同步好友验证数据
  Future<void> _syncFriendVerifyData(
    FriendVerifyService friendVerifyService,
    List<String> verifyIds,
  ) async {
    if (verifyIds.isEmpty) return;

    // 分批获取好友验证数据
    const batchSize = 50;
    for (int i = 0; i < verifyIds.length; i += batchSize) {
      final batchVerifyIds = verifyIds.sublist(
        i,
        (i + batchSize > verifyIds.length) ? verifyIds.length : i + batchSize,
      );

      final response = await getFriendVerifiesListByIdsApi(
        IGetFriendVerifiesListByIdsReq(verifyIds: batchVerifyIds),
      );
      if (response.code == 0 &&
          response.result != null &&
          response.result!.friendVerifies.isNotEmpty) {
        final friendVerifies = response.result!.friendVerifies
            .map(
              (verify) => FriendVerifiesCompanion(
                verifyId: Value(verify.verifyId),
                sendUserId: Value(verify.sendUserId),
                revUserId: Value(verify.revUserId),
                sendStatus: Value(verify.sendStatus),
                revStatus: Value(verify.revStatus),
                message: Value(verify.message),
                source: Value(verify.source),
                version: Value(verify.version),
                createdAt: Value(verify.createdAt),
                updatedAt: Value(verify.updatedAt),
              ),
            )
            .toList();

        await friendVerifyService.batchCreate(friendVerifies);
        // TODO: 发送通知到渲染进程
      }
    }
  }

  /// 更新游标
  Future<void> _updateFriendVerifiesCursor(
    DatasyncService datasyncService,
    int? version,
    int updatedAt,
  ) async {
    await datasyncService.upsert('friend_verifies', version, updatedAt);
  }

  String getStatus() => _syncStatus;
}

final friendVerifySyncModule = FriendVerifySyncModule();
