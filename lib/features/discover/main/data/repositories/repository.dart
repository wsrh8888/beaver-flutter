import 'package:beaver/core/database/database.dart';

class DiscoverItem {
  final String title;
  final String description;
  final String icon;
  final String route;

  const DiscoverItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}

class DiscoverMainRepository {
  Future<List<DiscoverItem>> getDiscoverItems() async {
    return [
      const DiscoverItem(
        title: '朋友圈',
        description: '分享生活瞬间',
        icon: 'moments',
        route: '/moments',
      ),
      const DiscoverItem(
        title: '扫一扫',
        description: '扫描二维码',
        icon: 'scan',
        route: '/scan',
      ),
      const DiscoverItem(
        title: '附近',
        description: '发现身边的朋友',
        icon: 'nearby',
        route: '/nearby',
      ),
    ];
  }
}
