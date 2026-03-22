import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/di/injection.dart';

/// 用户资料接收器 - 处理 users 表的操作 (对标 PC receivers/user/user.ts)
class UserReceiver {
  UserBusiness get _userBusiness => getIt<UserBusiness>();

  /**
   * 处理用户表更新通知
   */
  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final table = body['table'] as String?;
    final version = body['version'] as int?;
    final targetId = body['targetId'] as String?;

    if (table != 'users') {
      print('[UserReceiver] 收到非 users 表的更新: $table');
      return;
    }

    if (targetId != null && version != null) {
      await _userBusiness.handleTableUpdates(targetId, version);
    }
  }
}

final userReceiver = UserReceiver();