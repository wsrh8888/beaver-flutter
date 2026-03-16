import 'package:beaver/features/user/mine/data/models/user_info.dart';
import 'package:beaver/core/database/database.dart';

class MineRepository {
  final AppDatabase _database;

  MineRepository(this._database);

  Future<UserInfo> getUserInfo() async {
    final user = await _database.select(_database.users).getSingleOrNull();
    if (user != null) {
      return UserInfo(
        userId: user.id,
        nickname: user.nickname ?? 'Beaver',
        avatar: user.avatar,
      );
    }
    // 返回默认用户信息
    return UserInfo(
      userId: '未设�?,
      nickname: 'Beaver',
    );
  }
}

