import 'package:go_router/go_router.dart';
import 'package:beaver/features/chat/list/list.dart';
import 'package:beaver/features/chat/detail/detail.dart';
import 'package:beaver/features/chat/setting/setting.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> chatRoutes() {
  return [
    GoRoute(
      path: AppRoutes.chatList,
      builder: (context, state) => const ChatListPage(),
    ),
    GoRoute(
      path: AppRoutes.chatDetail,
      builder: (context, state) {
        final idFromQuery = state.uri.queryParameters['id'];
        final idFromExtra = state.extra is String
            ? state.extra as String
            : null;
        final conversationId = idFromQuery ?? idFromExtra;
        return ChatDetailPage(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: AppRoutes.chatSetting,
      builder: (context, state) {
        final idFromQuery = state.uri.queryParameters['id'];
        final idFromExtra = state.extra is String
            ? state.extra as String
            : null;
        final conversationId = idFromQuery ?? idFromExtra;
        return ChatSettingPage(conversationId: conversationId);
      },
    ),
  ];
}
