import 'package:beaver/api/friend.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/friend.dart';

/// 好友验证业务逻辑 (对标 PC business/friend/friend-verify.ts)
class FriendVerifyBusiness {
  final Map<String, int> _lastHandledVersionByVerifyId = {};

  /**
   * @description 处理好友验证表更新
   */
  Future<void> handleTableUpdates(
    String? userId,
    String? verifyId,
    int version,
  ) async {
    if (verifyId == null || verifyId.trim().isEmpty) {
      return;
    }

    // 1. 版本控制：如果已处理过更高或相等版本，则跳过
    final lastVersion = _lastHandledVersionByVerifyId[verifyId] ?? 0;
    if (version <= lastVersion) {
      return;
    }

    print(
      '[FriendVerifyBusiness] 正在同步好友验证增量: verifyId=$verifyId, version=$version',
    );

    // 2. 调用 API 拉取最新验证信息
    final response = await getFriendVerifiesListByIdsApi(
      IGetFriendVerifiesListByIdsReq(verifyIds: [verifyId]),
    );

    if (response.code != 0 || response.result == null) {
      print('[FriendVerifyBusiness] 拉取验证信息失败: ${response.msg}');
      return;
    }

    // 3. 批量更新本地数据库
    if (response.result!.friendVerifies.isNotEmpty) {
      final verifyService = getIt<FriendService>();
      final companions = response.result!.friendVerifies
          .map((item) => item.toCompanion())
          .toList();
      await verifyService.batchCreateVerifies(companions);
    }

    // 4. 更新版本缓存
    _lastHandledVersionByVerifyId[verifyId] = version;
    print('[FriendVerifyBusiness] 好友验证表同步完成');
  }
}
