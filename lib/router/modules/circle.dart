import 'package:go_router/go_router.dart';
import 'package:beaver/features/circle/detail/detail.dart';
import 'package:beaver/features/circle/feed/feed.dart';
import 'package:beaver/features/circle/join/join.dart';
import 'package:beaver/features/circle/list/list.dart';
import 'package:beaver/features/circle/post/post.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> circleRoutes() {
  return [
    GoRoute(
      path: AppRoutes.circleList,
      builder: (context, state) => const CircleListPage(),
    ),
    GoRoute(
      path: AppRoutes.circleFeed,
      builder: (context, state) {
        final circleId = state.uri.queryParameters['circleId'] ?? '';
        final circleName = state.uri.queryParameters['name'] ?? '';
        final memberCount =
            int.tryParse(state.uri.queryParameters['memberCount'] ?? '') ?? 0;
        final role =
            int.tryParse(state.uri.queryParameters['role'] ?? '') ?? 0;
        final avatar = state.uri.queryParameters['avatar'];
        final desc = state.uri.queryParameters['desc'];
        return CircleFeedPage(
          circleId: circleId,
          circleName: circleName,
          memberCount: memberCount,
          role: role,
          avatar: avatar,
          desc: desc,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.circlePost,
      builder: (context, state) {
        final circleId = state.uri.queryParameters['circleId'] ?? '';
        return CirclePostPage(circleId: circleId);
      },
    ),
    GoRoute(
      path: AppRoutes.circleDetail,
      builder: (context, state) {
        final postId = state.uri.queryParameters['postId'] ?? '';
        final replyCommentId = state.uri.queryParameters['replyCommentId'];
        return CircleDetailPage(
          postId: postId,
          replyCommentId: replyCommentId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.circleJoin,
      builder: (context, state) {
        final circleId = state.uri.queryParameters['circleId'] ?? '';
        return CircleJoinPage(circleId: circleId);
      },
    ),
  ];
}
