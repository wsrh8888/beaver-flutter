import 'package:go_router/go_router.dart';
import 'package:beaver/features/group/join/join.dart';
import 'package:beaver/features/group/list/list.dart';
import 'package:beaver/features/group/create/create.dart';
import 'package:beaver/features/group/config/config.dart';
import 'package:beaver/features/group/member/member.dart';
import 'package:beaver/features/group/notifications/page.dart';
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
      builder: (context, state) => GroupMemberPage(groupId: state.extra as String? ?? ''),
    ),
    GoRoute(
      path: AppRoutes.groupJoin,
      builder: (context, state) {
        final groupId = state.uri.queryParameters['groupId'] ?? '';
        final inviteCode = state.uri.queryParameters['inviteCode'] ?? '';
        return GroupJoinPage(
          groupId: groupId,
          inviteCode: inviteCode,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.groupNotifications,
      builder: (context, state) => const GroupNotificationsPage(),
    ),
  ];
}
