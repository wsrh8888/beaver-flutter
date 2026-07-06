import 'package:beaver/features/discover/main/data/models/discover.dart';
import 'package:beaver/router/routes.dart';

class DiscoverMainRepository {
  Future<List<DiscoverItem>> getDiscoverItems() async {
    return const [
      DiscoverItem(
        id: 'moment',
        title: '朋友圈',
        description: '分享生活瞬间',
        iconPath: 'assets/icons/tabbar/moment.svg',
        route: AppRoutes.momentList,
      ),
      DiscoverItem(
        id: 'circle',
        title: '圈子',
        description: '通过邀请或分享链接加入',
        iconPath: 'assets/icons/common/group.svg',
        route: AppRoutes.circleList,
      ),
      DiscoverItem(
        id: 'ai',
        title: 'AI 助手',
        description: '智能对话与协助',
        iconPath: 'assets/icons/common/ai.svg',
        route: '',
      ),
      DiscoverItem(
        id: 'scan',
        title: '扫一扫',
        description: '扫描二维码',
        iconPath: 'assets/icons/common/scan.svg',
        route: AppRoutes.scan,
      ),
    ];
  }
}
