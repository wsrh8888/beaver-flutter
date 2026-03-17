import 'package:go_router/go_router.dart';
import 'package:beaver/features/group/list/list.dart';
import 'package:beaver/features/group/create/create.dart';
import 'package:beaver/features/group/config/config.dart';
import 'package:beaver/features/group/member/member.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> groupRoutes() {
  return [
    GoRoute(
      path: AppRoutes.groupList,
      builder: (context, state) => const GroupListPage(),
    ),
    GoRoute(
      path: AppRoutes.groupCreate,
      builder: (context, state) => const CreateGroupPage(),
    ),
    GoRoute(
      path: AppRoutes.groupConfig,
      builder: (context, state) => const GroupConfigPage(),
    ),
    GoRoute(
      path: AppRoutes.groupMember,
      builder: (context, state) => const GroupMemberPage(),
    ),
  ];
}
