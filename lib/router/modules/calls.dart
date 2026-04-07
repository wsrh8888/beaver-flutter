import 'package:go_router/go_router.dart';
import 'package:beaver/features/calls/calls_page/calls_page.dart';
import 'package:beaver/features/calls/call/call_page.dart';
import 'package:beaver/features/calls/incoming/call_incoming.dart';
import 'package:beaver/types/call.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> callsRoutes() {
  return [
    GoRoute(
      path: AppRoutes.callsPage,
      builder: (context, state) => const CallsPage(),
    ),
    GoRoute(
      path: AppRoutes.call,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final callTypeStr = extras?['callType'] as String? ?? 'audio';
        final callType = callTypeStr == 'video' ? CallType.video : CallType.audio;
        return CallPage(
          conversationId: extras?['conversationId'] ?? '',
          roomToken: extras?['roomToken'] ?? '',
          liveKitUrl: extras?['liveKitUrl'] ?? '',
          callType: callType,
          isGroup: extras?['isGroup'] ?? extras?['conversationId']?.startsWith('g_') ?? false,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.callIncoming,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        return CallInvitationPage(
          conversationId: extras?['conversationId'] ?? '',
          roomId: extras?['roomId'] ?? '',
        );
      },
    ),
  ];
}
