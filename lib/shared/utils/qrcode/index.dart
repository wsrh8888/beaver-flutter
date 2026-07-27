import 'package:flutter/material.dart';
import 'package:beaver/shared/utils/qrcode/handlers/add_friend/index.dart';
import 'package:beaver/shared/utils/qrcode/handlers/webview/index.dart';
import 'package:beaver/shared/utils/qrcode/handlers/join_group/index.dart';
import 'package:beaver/shared/utils/qrcode/handlers/join_circle/index.dart';
import 'package:beaver/shared/utils/qrcode/handlers/oauth/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';

export 'handlers/oauth/index.dart' show pendingOAuthSceneKey, consumePendingOAuthScene;
export 'handlers/join_circle/index.dart'
    show
        pendingCircleShareKey,
        savePendingCircleShare,
        consumePendingCircleShare,
        buildCircleShareLink,
        buildCircleInviteQrValue,
        parseCircleIdFromShare;

enum QrCodeType { oauth, addFriend, joinGroup, joinCircle, webview, unknown }

QrCodeType detectQrCodeType(String code) {
  if (isOAuthQr(code)) {
    return QrCodeType.oauth;
  }
  if (isAddFriendQr(code)) {
    return QrCodeType.addFriend;
  }
  if (isJoinGroupQr(code)) {
    return QrCodeType.joinGroup;
  }
  if (isJoinCircleQr(code)) {
    return QrCodeType.joinCircle;
  }
  if (isWebviewQr(code)) {
    return QrCodeType.webview;
  }
  return QrCodeType.unknown;
}

void handleQrCode(BuildContext context, String code) {
  final value = code.trim();
  if (value.isEmpty) {
    BeaverToast.show(context, '无效的二维码');
    return;
  }

  switch (detectQrCodeType(value)) {
    case QrCodeType.oauth:
      oauthQrHandler.handle(context, value);
    case QrCodeType.addFriend:
      addFriendQrHandler.handle(context, value);
    case QrCodeType.joinGroup:
      joinGroupQrHandler.handle(context, value);
    case QrCodeType.joinCircle:
      joinCircleQrHandler.handle(context, value);
    case QrCodeType.webview:
      webviewQrHandler.handle(context, value);
    case QrCodeType.unknown:
      BeaverToast.show(context, '无效的二维码');
  }
}
