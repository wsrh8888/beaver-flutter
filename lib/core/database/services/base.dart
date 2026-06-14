import '../db.dart';

/// 数据访问基类
abstract class BaseService {
  const BaseService();

  AppDatabase get db => DatabaseManager.instance;
}
