import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/friend.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/friend.dart';

/// 好友验证同步
class FriendVerifySync {
  Future<void> checkAndSync() async {
    print('[FriendVerifySync] 开始同步好友验证数据');

    final datasyncService = getIt<DatasyncService>();
    final friendService = getIt<FriendService>();

    // 1. 获取本地同步游标（version=-1 表示发现全部变更，对齐 PC）
    final cursor = await datasyncService.get('friend_verifies');
    final lastSyncVersion = cursor?.version ?? 0;

    // 2. 获取服务器上变更的好友验证列表 (摘要)
    final response = await datasyncGetSyncFriendVerifiesApi(
      IGetSyncFriendVerifiesReq(since: lastSyncVersion),
    );

    if (response.code != 0 || response.result == null) {
      print('[FriendVerifySync] 获取好友验证版本失败: ${response.msg}');
      return;
    }

    final verifyVersions = response.result!.friendVerifyVersions;
    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比过滤
    final needUpdateVerifyIds = await _compareAndFilterVersions(
      friendService,
      verifyVersions,
    );

    if (needUpdateVerifyIds.isNotEmpty) {
      // 4. 同步具体验证数据
      await _syncVerifyData(friendService, needUpdateVerifyIds);

      // 5. 更新游标
      final maxVersion = verifyVersions
          .map((e) => e.version)
          .reduce((a, b) => a > b ? a : b);
      await datasyncService.upsert(
        'friend_verifies',
        maxVersion,
        serverTimestamp,
      );
    } else {
      await datasyncService.upsert('friend_verifies', null, serverTimestamp);
    }

    print('[FriendVerifySync] 好友验证数据同步完成');
  }

  Future<List<String>> _compareAndFilterVersions(
    FriendService friendService,
    List<IFriendVerifyVersionItem> serverVersions,
  ) async {
    if (serverVersions.isEmpty) return [];

    final verifyIds = serverVersions.map((e) => e.verifyId).toList();
    final localRecords = await friendService.getFriendVerifiesByIds(verifyIds);
    final localMap = {for (var r in localRecords) r.verifyId: r.version};

    final List<String> needUpdate = [];
    for (final sv in serverVersions) {
      final localVersion = localMap[sv.verifyId] ?? 0;
      if (localVersion < sv.version) {
        needUpdate.add(sv.verifyId);
      }
    }
    return needUpdate;
  }

  Future<void> _syncVerifyData(
    FriendService friendService,
    List<String> verifyIds,
  ) async {
    const int batchSize = 50;
    for (int i = 0; i < verifyIds.length; i += batchSize) {
      final batchIds = verifyIds.sublist(
        i,
        i + batchSize > verifyIds.length ? verifyIds.length : i + batchSize,
      );

      final response = await getFriendVerifiesListByIdsApi(
        IGetFriendVerifiesListByIdsReq(verifyIds: batchIds),
      );
      if (response.code == 0 && response.result != null) {
        final companions = response.result!.friendVerifies
            .map((e) => e.toCompanion())
            .toList();
        await friendService.batchCreateVerifies(companions);
      }
    }
  }
}

final friendVerifySync = FriendVerifySync();
