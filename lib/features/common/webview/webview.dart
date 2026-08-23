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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:beaver/features/common/webview/bloc/bloc.dart';
import 'package:beaver/features/common/webview/bloc/event.dart';
import 'package:beaver/features/common/webview/bloc/state.dart';
import 'package:beaver/features/common/webview/bridge/beaver_bridge.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String? title;

  const WebViewPage({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  late final WebViewBloc _bloc;
  late final BeaverBridge _bridge;
  late final String _fallbackTitle;

  @override
  void initState() {
    super.initState();
    _bloc = WebViewBloc(url: widget.url);
    _fallbackTitle = _resolveFallbackTitle(widget.url);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            _bloc.add(WebViewProgressChanged(progress.toDouble()));
          },
          onPageStarted: (String url) {
            _bloc.add(WebViewPageStarted());
          },
          onPageFinished: (String url) async {
            await _bridge.inject();
            final pageTitle = await _readPageTitle();
            if (!mounted) return;
            _bloc.add(WebViewPageFinished(pageTitle: pageTitle));
          },
          onWebResourceError: (WebResourceError error) {
            _bloc.add(WebViewErrorOccurred(error.description));
          },
        ),
      );

    _bridge = BeaverBridge(_controller);
    _bridge.attach().then((_) {
      _controller.loadRequest(Uri.parse(widget.url));
    });
  }

  String _resolveFallbackTitle(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '网页';
    if (uri.host.isNotEmpty) return uri.host;
    return '网页';
  }

  Future<String?> _readPageTitle() async {
    try {
      final title = await _controller.runJavaScriptReturningResult(
        'document.title',
      );
      final text = title?.toString().replaceAll('"', '').trim();
      if (text != null && text.isNotEmpty) return text;
    } catch (_) {}
    return null;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<WebViewBloc, WebViewState>(
        builder: (context, state) {
          final displayTitle = widget.title ?? state.pageTitle ?? _fallbackTitle;

          return BeaverLayout(
            title: displayTitle,
            showBack: true,
            onBack: () => context.pop(),
            showBackground: false,
            isScrollable: false,
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (state.progress < 100)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: state.progress / 100,
                      backgroundColor: Colors.transparent,
                      color: const Color(0xFFFF7D45),
                      minHeight: 2.w,
                    ),
                  ),
                if (state.status == WebViewStatus.error)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        SizedBox(height: 16.w),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            state.errorMessage ?? '加载失败',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _controller.reload(),
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
