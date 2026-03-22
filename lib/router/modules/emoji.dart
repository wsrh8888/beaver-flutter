import 'package:beaver/features/emoji/detail/index.dart';
import 'package:beaver/features/emoji/shop/index.dart';
import 'package:beaver/router/routes.dart';
import 'package:go_router/go_router.dart';

List<RouteBase> emojiRoutes() {
  return [
    GoRoute(
      path: AppRoutes.emojiShop,
      builder: (context, state) => const EmojiShopScreen(),
    ),
    GoRoute(
      path: AppRoutes.emojiDetail,
      builder: (context, state) {
        final emojiId = state.uri.queryParameters['emojiId'] ?? '';
        return EmojiDetailScreen(emojiId: emojiId);
      },
    ),
  ];
}
