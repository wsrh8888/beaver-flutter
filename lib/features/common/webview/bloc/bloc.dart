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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/common/webview/bloc/event.dart';
import 'package:beaver/features/common/webview/bloc/state.dart';

class WebViewBloc extends Bloc<WebViewEvent, WebViewState> {
  WebViewBloc({required String url}) : super(WebViewState(url: url)) {
    on<WebViewProgressChanged>(_onProgressChanged);
    on<WebViewPageStarted>(_onPageStarted);
    on<WebViewPageFinished>(_onPageFinished);
    on<WebViewErrorOccurred>(_onErrorOccurred);
  }

  void _onProgressChanged(WebViewProgressChanged event, Emitter<WebViewState> emit) {
    emit(state.copyWith(progress: event.progress));
  }

  void _onPageStarted(WebViewPageStarted event, Emitter<WebViewState> emit) {
    emit(state.copyWith(status: WebViewStatus.loading, progress: 0));
  }

  void _onPageFinished(WebViewPageFinished event, Emitter<WebViewState> emit) {
    emit(state.copyWith(
      status: WebViewStatus.success,
      progress: 100,
      pageTitle: event.pageTitle,
    ));
  }

  void _onErrorOccurred(WebViewErrorOccurred event, Emitter<WebViewState> emit) {
    emit(state.copyWith(status: WebViewStatus.error, errorMessage: event.errorMessage));
  }
}
