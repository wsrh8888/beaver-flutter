import 'package:beaver/core/database/db.dart';
import 'package:beaver/features/contact/search/data/models/search.dart';

class SearchContactRepository {
  final AppDatabase _database;

  SearchContactRepository(this._database);

  Future<User?> searchUser(String email) async {
    // 模拟搜索用户
    await Future.delayed(const Duration(seconds: 1));
    return const User(
      userId: '123456',
      nickname: '李四',
      avatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
    );
  }

  Future<bool> addFriend(String userId) async {
    // 模拟发送好友请求
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
