import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:beaver/features/common/webview/bloc/bloc.dart';
import 'package:beaver/features/common/webview/bloc/event.dart';
import 'package:beaver/features/common/webview/bloc/state.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  void initState() {
    super.initState();
    _bloc = WebViewBloc(url: widget.url);
    
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
          onPageFinished: (String url) {
            _bloc.add(WebViewPageFinished());
          },
          onWebResourceError: (WebResourceError error) {
            _bloc.add(WebViewErrorOccurred(error.description));
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
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
          return BeaverLayout(
            title: widget.title ?? '网页',
            showBack: true,
            onBack: () => Navigator.of(context).pop(),
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
                        Text(state.errorMessage ?? '加载失败'),
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
