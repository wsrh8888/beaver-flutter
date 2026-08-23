/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'package:go_router/go_router.dart';
import 'package:beaver/features/circle/detail/detail.dart';
import 'package:beaver/features/circle/feed/feed.dart';
import 'package:beaver/features/circle/join/join.dart';
import 'package:beaver/features/circle/list/list.dart';
import 'package:beaver/features/circle/post/post.dart';
import 'package:beaver/features/circle/setting/setting.dart';
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
        final inviteCode = state.uri.queryParameters['inviteCode'] ?? '';
        return CircleJoinPage(
          circleId: circleId,
          inviteCode: inviteCode,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.circleSetting,
      builder: (context, state) {
        final circleId = state.uri.queryParameters['circleId'] ?? '';
        return CircleSettingPage(circleId: circleId);
      },
    ),
  ];
}
