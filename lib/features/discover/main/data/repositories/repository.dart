import 'package:beaver/core/database/database.dart';
import 'package:beaver/features/discover/main/data/models/discover.dart';

class DiscoverMainRepository {
  Future<List<DiscoverItem>> getDiscoverItems() async {
    return [
      const DiscoverItem(
        id: '1',
        title: '朋友圈',
        description: '分享生活瞬间',
        icon: 'moments',
        route: '/moments',
      ),
      const DiscoverItem(
        id: '2',
        title: '扫一扫',
        description: '扫描二维码',
        icon: 'scan',
        route: '/scan',
      ),
      const DiscoverItem(
        id: '3',
        title: '附近',
        description: '发现身边的朋友',
        icon: 'nearby',
        route: '/nearby',
      ),
    ];
  }
}
