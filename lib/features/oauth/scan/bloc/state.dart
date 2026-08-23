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

enum OAuthScanConfirmStatus { initial, loading, ready, submitting, success, error }

class OAuthScanConfirmState extends Equatable {
  final OAuthScanConfirmStatus status;
  final String sceneId;
  final String appName;
  final String appIcon;
  final List<String> scopes;
  final String? errorMessage;

  const OAuthScanConfirmState({
    this.status = OAuthScanConfirmStatus.initial,
    this.sceneId = '',
    this.appName = '',
    this.appIcon = '',
    this.scopes = const [],
    this.errorMessage,
  });

  OAuthScanConfirmState copyWith({
    OAuthScanConfirmStatus? status,
    String? sceneId,
    String? appName,
    String? appIcon,
    List<String>? scopes,
    String? errorMessage,
  }) {
    return OAuthScanConfirmState(
      status: status ?? this.status,
      sceneId: sceneId ?? this.sceneId,
      appName: appName ?? this.appName,
      appIcon: appIcon ?? this.appIcon,
      scopes: scopes ?? this.scopes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sceneId, appName, appIcon, scopes, errorMessage];
}
