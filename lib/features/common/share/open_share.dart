import 'package:beaver/features/common/share/share_args.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/utils/invite/invite.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 打开统一实体分享全屏页（群 / 圈共用）
Future<void> openEntityShare(
  BuildContext context, {
  required int cardType,
  required String id,
  required String name,
  required String inviteUrl,
  String? avatar,
}) {
  final link = inviteUrl.trim();
  final code = parseInviteCode(link) ?? '';

  if (cardType == 2 || cardType == 3) {
    if (link.isEmpty || code.isEmpty) {
      BeaverToast.show(context, '暂无可用邀请链接');
      return Future.value();
    }
  }

  return context.push<void>(
    AppRoutes.entityShare,
    extra: EntityShareArgs(
      cardType: cardType,
      id: id,
      name: name,
      inviteUrl: link,
      avatar: avatar,
    ),
  );
}

Future<void> openGroupShare(
  BuildContext context, {
  required String groupId,
  required String groupName,
  required String inviteUrl,
  String? avatar,
}) {
  return openEntityShare(
    context,
    cardType: 2,
    id: groupId,
    name: groupName,
    inviteUrl: inviteUrl,
    avatar: avatar,
  );
}

Future<void> openCircleShare(
  BuildContext context, {
  required String circleId,
  required String circleName,
  required String inviteUrl,
  String? avatar,
}) {
  return openEntityShare(
    context,
    cardType: 3,
    id: circleId,
    name: circleName,
    inviteUrl: inviteUrl,
    avatar: avatar,
  );
}
