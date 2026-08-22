import 'package:beaver/features/discover/main/data/models/discover.dart';

class DiscoverMainRepository {
  Future<List<DiscoverItem>> getDiscoverItems() async {
    // 底栏已改为「工作台」；朋友圈迁入工作台；AI / 扫一扫入口已移除
    return const [];
  }
}
