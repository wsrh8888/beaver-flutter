import 'package:beaver/core/database/database.dart';
import 'package:beaver/core/network/api/api.dart';
import 'package:beaver/di/injection.dart';

import '../base/base.dart';

/// 用户同步队列项 (对标 desktop UserSyncItem)
class UserSyncItem extends QueueItem {
  @override
  final String key;
  @override
  final dynamic data;
  @override
  final int timestamp;
  final String userId;
  final int version;

  UserSyncItem({
    required this.userId,
    required this.version,
    required this.key,
    required this.data,
    required this.timestamp,
  });
}

/// 用户业务 (对标 desktop business/user/user.ts)
class UserBusiness extends BaseBusiness<UserSyncItem> {
  UserBusiness() : super(BusinessBatchConfig(queueSizeLimit: 20, delayMs: 1000));

  @override
  String get businessName => 'UserBusiness';

  void handleTableUpdates(String userId, int version) {
    addToQueue(UserSyncItem(
      key: userId,
      data: {'userId': userId, 'version': version},
      timestamp: DateTime.now().millisecondsSinceEpoch,
      userId: userId,
      version: version,
    ));
  }

  @override
  Future<void> processBatchRequests(List<UserSyncItem> items) async {
    final userApi = getIt<UserApi>();
    final userService = getIt<UserService>();
    await Future.delayed(Duration.zero);
  }
}
