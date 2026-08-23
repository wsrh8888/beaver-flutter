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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum WsConnectionStatus {
  connected,
  connecting,
  syncing,
  disconnected,
}

class WsStoreState extends Equatable {
  final WsConnectionStatus status;

  const WsStoreState({this.status = WsConnectionStatus.disconnected});

  bool get showBanner => status != WsConnectionStatus.connected;

  String get bannerText {
    switch (status) {
      case WsConnectionStatus.connecting:
        return '连接中...';
      case WsConnectionStatus.syncing:
        return '收取中...';
      case WsConnectionStatus.disconnected:
        return '网络未连接';
      case WsConnectionStatus.connected:
        return '';
    }
  }

  WsStoreState copyWith({WsConnectionStatus? status}) {
    return WsStoreState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}

class WsStore extends Cubit<WsStoreState> {
  WsStore() : super(const WsStoreState(status: WsConnectionStatus.connecting));

  void setConnecting() {
    if (state.status == WsConnectionStatus.connecting) return;
    emit(state.copyWith(status: WsConnectionStatus.connecting));
  }

  void setSyncing() {
    emit(state.copyWith(status: WsConnectionStatus.syncing));
  }

  void setConnected() {
    emit(state.copyWith(status: WsConnectionStatus.connected));
  }

  void setDisconnected() {
    emit(state.copyWith(status: WsConnectionStatus.disconnected));
  }
}
