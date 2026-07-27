import 'package:beaver/features/discover/main/data/models/discover.dart';
import 'package:beaver/router/routes.dart';

class DiscoverMainRepository {
  Future<List<DiscoverItem>> getDiscoverItems() async {
    return const [
      DiscoverItem(
        id: 'workbench',
        title: '工作台',
        description: '企业应用与能力入口',
        iconPath: 'assets/icons/tabbar/workbench.svg',
        route: AppRoutes.workbenchHome,
      ),
      DiscoverItem(
        id: 'moment',
        title: '朋友圈',
        description: '分享生活瞬间',
        iconPath: 'assets/icons/tabbar/moment.svg',
        route: AppRoutes.momentList,
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
