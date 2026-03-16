import 'package:go_router/go_router.dart';
import 'package:beaver/features/chat/chat_list/chat_list.dart';


class ChatRoutes {
  static const String chatList = '/chat/list';
  static const String chatDetail = '/chat/:chatId';
  static const String chatSetting = '/chat/:chatId/setting';
}

List<GoRoute> chatRoutes = [
  GoRoute(
    path: ChatRoutes.chatList,
    builder: (context, state) => const ChatListPage(),
  ),
  // 可以在这里添加更多聊天相关路由
];

