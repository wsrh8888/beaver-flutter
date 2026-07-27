import 'package:beaver/features/chat/list/list.dart';
import 'package:beaver/features/chat/detail/detail.dart';
import 'package:beaver/features/chat/forward_picker/picker_page.dart';
import 'package:beaver/features/chat/forward_detail/detail_page.dart';
import 'package:beaver/features/chat/share_picker/picker_page.dart';
import 'package:beaver/features/chat/private_setting/private_setting.dart';
import 'package:beaver/features/chat/group_setting/group_setting.dart';
import 'package:beaver/router/routes.dart';
import 'package:go_router/go_router.dart';

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
        final idFromExtra = state.extra is String ? state.extra as String : null;
        final conversationId = idFromQuery ?? idFromExtra;
        return ChatDetailPage(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: AppRoutes.privateChatSetting,
      builder: (context, state) {
        final idFromQuery = state.uri.queryParameters['id'];
        final idFromExtra = state.extra is String ? state.extra as String : null;
        final conversationId = idFromQuery ?? idFromExtra;
        return PrivateSettingPage(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: AppRoutes.groupChatSetting,
      builder: (context, state) {
        final idFromQuery = state.uri.queryParameters['id'];
        final idFromExtra = state.extra is String ? state.extra as String : null;
        final conversationId = idFromQuery ?? idFromExtra;
        return GroupSettingPage(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: AppRoutes.chatForward,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final messageIds = extra?['messageIds'] as List<String>? ?? [];
        final forwardMode = extra?['forwardMode'] as int? ?? 1;
        return ForwardPickerPage(
          messageIds: messageIds,
          forwardMode: forwardMode,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.chatForwardDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final title = extra?['title'] as String? ?? '聊天记录';
        final recordId = extra?['recordId'] as String?;
        return ForwardDetailPage(title: title, recordId: recordId);
      },
    ),
    GoRoute(
      path: AppRoutes.chatShareConversation,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return ShareConversationPickerPage(payload: extra);
      },
    ),
  ];
}
