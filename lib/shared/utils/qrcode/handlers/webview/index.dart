import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/router/routes.dart';

bool isWebviewQr(String code) {
  return code.startsWith('http://') || code.startsWith('https://');
}

class WebviewQrHandler {
  void handle(BuildContext context, String code) {
    context.replace(
      '${AppRoutes.webview}?url=${Uri.encodeComponent(code)}',
    );
  }
}

final webviewQrHandler = WebviewQrHandler();
