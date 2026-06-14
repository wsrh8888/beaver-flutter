import 'package:go_router/go_router.dart';
import 'package:beaver/features/moment/list/list.dart';
import 'package:beaver/features/moment/detail/detail.dart';
import 'package:beaver/features/moment/post/post.dart';
import 'package:beaver/features/moment/messages/page.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> momentRoutes() {
  return [
    GoRoute(
      path: AppRoutes.momentList,
      builder: (context, state) => const MomentListPage(),
    ),
    GoRoute(
      path: AppRoutes.momentDetail,
      builder: (context, state) {
        final momentId = state.uri.queryParameters['id'] ?? '';
        final replyCommentId = state.uri.queryParameters['replyCommentId'];
        return MomentDetailPage(
          momentId: momentId,
          replyCommentId: replyCommentId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.momentPost,
      builder: (context, state) => const PostMomentPage(),
    ),
    GoRoute(
      path: AppRoutes.momentMessages,
      builder: (context, state) => const MomentMessagesPage(),
    ),
  ];
}
