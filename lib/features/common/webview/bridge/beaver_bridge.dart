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

import 'dart:convert';

import 'package:beaver/common/config/config.dart';
import 'package:beaver/common/config/env.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/user/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 内嵌 H5 JSBridge，对齐 desktop `window.beaverBridge`
/// API：app.getEnv / user.getUserInfo，返回 { code, msg, result }
class BeaverBridge {
  static const channelName = 'BeaverBridgeChannel';

  final WebViewController controller;

  BeaverBridge(this.controller);

  Future<void> attach() async {
    await controller.addJavaScriptChannel(
      channelName,
      onMessageReceived: _onMessage,
    );
  }

  Future<void> inject() async {
    await controller.runJavaScript(_buildInjectScript());
  }

  Future<void> _onMessage(JavaScriptMessage message) async {
    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(message.message) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    final id = payload['id']?.toString() ?? '';
    final method = payload['method']?.toString() ?? '';
    if (id.isEmpty || method.isEmpty) return;

    final result = _dispatch(method);
    final encoded = jsonEncode(result);
    await controller.runJavaScript(
      'window.__beaverBridgeCallback(${jsonEncode(id)}, $encoded);',
    );
  }

  Map<String, dynamic> _dispatch(String method) {
    switch (method) {
      case 'app.getEnv':
        return {
          'code': 0,
          'msg': 'ok',
          'result': {
            'env': currentEnv.name,
            'deviceId': AppConfig.deviceId,
          },
        };
      case 'user.getUserInfo':
        return _getUserInfo();
      default:
        return {
          'code': 1,
          'msg': 'unknown method: $method',
          'result': null,
        };
    }
  }

  Map<String, dynamic> _getUserInfo() {
    final userStore = getIt<UserStore>();
    final contactStore = getIt<ContactStore>();
    final info = userStore.getUserInfo(contactStore);
    if (info == null || info.userId.isEmpty) {
      return {'code': 401, 'msg': 'not logged in', 'result': null};
    }
    return {
      'code': 0,
      'msg': 'ok',
      'result': {
        'userId': info.userId,
        'nickName': info.nickname,
        'avatar': info.avatar ?? '',
      },
    };
  }

  String _buildInjectScript() {
    return '''
(function () {
  if (window.beaverBridge) return;

  window.__beaverBridgePending = window.__beaverBridgePending || {};

  window.__beaverBridgeCallback = function (id, result) {
    var pending = window.__beaverBridgePending[id];
    if (pending) {
      pending(result);
      delete window.__beaverBridgePending[id];
    }
  };

  function invoke(method, params) {
    return new Promise(function (resolve) {
      var id = String(Date.now()) + '_' + Math.random().toString(36).slice(2);
      window.__beaverBridgePending[id] = resolve;
      $channelName.postMessage(JSON.stringify({
        id: id,
        method: method,
        params: params || {}
      }));
    });
  }

  window.beaverBridge = {
    app: {
      getEnv: function () { return invoke('app.getEnv', {}); }
    },
    user: {
      getUserInfo: function () { return invoke('user.getUserInfo', {}); }
    }
  };
})();
''';
  }
}
