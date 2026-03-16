import 'package:beaver/features/discover/main/data/models/discover.dart';

class DiscoverRepository {
  Future<List<DiscoverItem>> getDiscoverItems() async {
    // 模拟获取发现项目
    await Future.delayed(const Duration(seconds: 1));
    return [
      DiscoverItem(
        id: '1',
        title: '附近的人',
        description: '发现身边的朋�?,
        icon: 'nearby',
        route: '/nearby',
      ),
      DiscoverItem(
        id: '2',
        title: '群聊',
        description: '加入感兴趣的群组',
        icon: 'group',
        route: '/groupList',
      ),
      DiscoverItem(
        id: '3',
        title: '扫一�?,
        description: '扫描二维�?,
        icon: 'scan',
        route: '/qrcode',
      ),
      DiscoverItem(
        id: '4',
        title: '朋友�?,
        description: '分享生活瞬间',
        icon: 'moment',
        route: '/moment',
      ),
    ];
  }
}

