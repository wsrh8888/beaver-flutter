import '../db.dart';

/// 数据访问基类：持有 [AppDatabase]，便于子类复用与单测注入 mock
abstract class BaseService {
  final AppDatabase db;
  const BaseService(this.db);
}
