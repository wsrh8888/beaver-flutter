import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/friend.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/friend.dart';

import 'package:beaver/core/datasync/friend/friend_verify.dart';

/// 好友同步
class FriendSync {
  Future<void> checkAndSync() async {
    // 1. 同步好友资料
    await _syncFriends();
    // 2. 同步好友验证
    await friendVerifySync.checkAndSync();
  }

  Future<void> _syncFriends() async {
    print('[FriendSync] 开始同步好友数据');
    
    final datasyncService = getIt<DatasyncService>();
    final friendService = getIt<FriendService>();

    // 1. 获取本地同步时间戳
    final localCursor = await datasyncService.get('friends');
    final lastSyncTime = localCursor?.version ?? 0;

    // 2. 获取服务器上变更的好友版本信息
    final response = await datasyncGetSyncFriendsApi(IGetSyncFriendsReq(since: lastSyncTime));
    
    if (response.code != 0 || response.result == null) {
      print('[FriendSync] 获取好友版本失败: ${response.msg}');
      return;
    }

    final friendVersions = response.result!.friendVersions;
    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比本地数据，过滤出需要更新的数据
    final needUpdateFriendIds = await _compareAndFilterFriendVersions(friendService, friendVersions);

    if (needUpdateFriendIds.isNotEmpty) {
      // 4. 同步好友具体数据
      await _syncFriendData(friendService, needUpdateFriendIds);
      
      // 5. 更新游标
      final maxVersion = friendVersions.map((e) => e.version).reduce((a, b) => a > b ? a : b);
      await datasyncService.upsert('friends', maxVersion, serverTimestamp);
    } else {
      // 没有更新也同步一下时间戳
      await datasyncService.upsert('friends', null, serverTimestamp);
    }

    print('[FriendSync] 好友同步完成');
  }

  Future<List<String>> _compareAndFilterFriendVersions(
    FriendService friendService,
    List<IFriendVersionItem> friendVersions,
  ) async {
    if (friendVersions.isEmpty) return [];

    final friendshipIds = friendVersions.map((e) => e.friendId).toList();
    final existingFriends = await friendService.getFriendRecordsByIds(friendshipIds);
    final existingMap = {for (var f in existingFriends) f.friendId: f};

    final List<String> needUpdate = [];
    for (final sv in friendVersions) {
      final local = existingMap[sv.friendId];
      if (local == null || local.version < sv.version) {
        needUpdate.add(sv.friendId);
      }
    }
    return needUpdate;
  }

  Future<void> _syncFriendData(FriendService friendService, List<String> friendIds) async {
    const int batchSize = 50;
    for (int i = 0; i < friendIds.length; i += batchSize) {
      final batchIds = friendIds.sublist(i, i + batchSize > friendIds.length ? friendIds.length : i + batchSize);
      
      final response = await getFriendsListByIdsApi(IGetFriendsListByIdsReq(friendIds: batchIds));
      if (response.code == 0 && response.result != null) {
        await friendService.batchCreate(response.result!.friends);
        // TODO: 发送通知（可使用 event_bus 或扩展 Bloc）
      }
    }
  }
}

final friendSync = FriendSync();