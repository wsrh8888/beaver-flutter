import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/friend.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/shared/utils/storage_util.dart';

/// 好友数据同步模块
class FriendSyncModule {
  String _syncStatus = 'PENDING';

  /// 检查并同步
  Future<void> checkAndSync() async {
    print('[FriendSyncModule] 开始同步好友数据');
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) return;

    try {
      final datasyncService = getIt<DatasyncService>();
      final friendService = getIt<FriendService>();

      // 获取本地同步时间戳
      final localCursor = await datasyncService.get('friends');
      final lastSyncTime = localCursor?.version ?? 0;

      // 获取服务器上变更的好友版本信息
      final response = await datasyncGetSyncFriendsApi(IGetSyncFriendsReq(since: lastSyncTime));
      if (response.code != 0 || response.result == null) {
        print('[FriendSyncModule] 获取好友版本失败: ${response.msg}');
        return;
      }

      final friendVersions = response.result!.friendVersions;
      final serverTimestamp = response.result!.serverTimestamp;

      // 对比本地数据，过滤出需要更新的数据
      final needUpdateFriendshipIds = await _compareAndFilterFriendVersions(friendService, friendVersions);

      if (needUpdateFriendshipIds.isNotEmpty) {
        // 有需要更新的好友数据
        await _syncFriendData(friendService, needUpdateFriendshipIds);
        
        // 从变更的数据中找到最大的版本号
        int maxVersion = 0;
        for (var item in friendVersions) {
          if (item.version > maxVersion) maxVersion = item.version;
        }

        await _updateFriendsCursor(datasyncService, maxVersion, serverTimestamp);
      } else {
        // 没有需要更新的数据，直接更新时间戳
        await _updateFriendsCursor(datasyncService, null, serverTimestamp);
      }

      _syncStatus = 'COMPLETED';
    } catch (error) {
      _syncStatus = 'FAILED';
      print('[FriendSyncModule] 好友数据同步失败: $error');
    }
  }

  /// 对比本地数据，过滤出需要更新的好友关系ID
  Future<List<String>> _compareAndFilterFriendVersions(
    FriendService friendService,
    List<IFriendVersionItem> friendVersions,
  ) async {
    if (friendVersions.isEmpty) return [];

    // 提取所有变更的好友关系ID
    final friendshipIds = friendVersions.map((item) => item.friendId).where((id) => id.trim().isNotEmpty).toList();
    if (friendshipIds.isEmpty) return [];

    // 查询本地已存在的记录
    final existingFriends = await friendService.getFriendRecordsByIds(friendshipIds);
    final existingFriendsMap = {for (var f in existingFriends) f.friendId: f};

    // 过滤出需要更新的 friendshipIds
    final List<String> needUpdateFriendshipIds = [];
    for (var id in friendshipIds) {
      final existingFriend = existingFriendsMap[id];
      final serverVersion = friendVersions.firstWhere((item) => item.friendId == id).version;

      if (existingFriend == null || existingFriend.version < serverVersion) {
        needUpdateFriendshipIds.add(id);
      }
    }

    return needUpdateFriendshipIds;
  }

  /// 同步好友数据
  Future<void> _syncFriendData(FriendService friendService, List<String> friendshipIds) async {
    if (friendshipIds.isEmpty) return;

    // 分批获取好友数据
    const batchSize = 50;
    for (int i = 0; i < friendshipIds.length; i += batchSize) {
      final batchIds = friendshipIds.sublist(i, (i + batchSize > friendshipIds.length) ? friendshipIds.length : i + batchSize);

      final response = await getFriendsListByIdsApi(IGetFriendsListByIdsReq(friendIds: batchIds));
      if (response.code == 0 && response.result != null && response.result!.friends.isNotEmpty) {
        await friendService.batchCreate(response.result!.friends);
        // TODO: 发送通知到渲染进程
      }
    }
  }

  /// 更新游标
  Future<void> _updateFriendsCursor(DatasyncService datasyncService, int? version, int updatedAt) async {
    await datasyncService.upsert('friends', version, updatedAt);
  }

  String getStatus() => _syncStatus;
}

final friendSyncModule = FriendSyncModule();
