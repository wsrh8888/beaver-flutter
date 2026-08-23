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

import 'dart:async';

import 'package:beaver/api/notification.dart';
import 'package:beaver/core/business/index.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/notification.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationStoreState extends Equatable {
  final int unreadCount;
  final Map<String, int> unreadByCategory;

  const NotificationStoreState({
    this.unreadCount = 0,
    this.unreadByCategory = const {},
  });

  int categoryUnread(String category) => unreadByCategory[category] ?? 0;

  int get momentUnread => categoryUnread('moment');

  NotificationStoreState copyWith({
    int? unreadCount,
    Map<String, int>? unreadByCategory,
  }) {
    return NotificationStoreState(
      unreadCount: unreadCount ?? this.unreadCount,
      unreadByCategory: unreadByCategory ?? this.unreadByCategory,
    );
  }

  @override
  List<Object?> get props => [unreadCount, unreadByCategory];
}

class NotificationStore extends Cubit<NotificationStoreState> {
  final NotificationInboxBusiness _inboxBusiness;
  StreamSubscription? _subscription;
  Timer? _initDebounceTimer;

  NotificationStore({NotificationInboxBusiness? inboxBusiness})
      : _inboxBusiness = inboxBusiness ?? getIt<NotificationInboxBusiness>(),
        super(const NotificationStoreState()) {
    _subscription = _inboxBusiness.inboxUpdateStream.listen((_) {
      _initDebounceTimer?.cancel();
      _initDebounceTimer = Timer(const Duration(milliseconds: 200), init);
    });
    init();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _initDebounceTimer?.cancel();
    return super.close();
  }

  Future<void> init() async {
    final userId = DatabaseManager.currentUserId;
    if (userId == null) return;

    final summary = await _inboxBusiness.getUnreadSummary(userId);
    final byCat = Map<String, int>.from(
      (summary['byCat'] as Map<String, int>?) ?? {},
    );

    emit(
      state.copyWith(
        unreadCount: summary['total'] as int? ?? 0,
        unreadByCategory: byCat,
      ),
    );
  }

  Future<void> markCategoryAsViewed(String category) async {
    if (state.categoryUnread(category) == 0) return;

    final response = await markReadByCategoryApi(
      IMarkReadByCategoryReq(category: category),
    );
    if (response.code != 0) return;

    final userId = DatabaseManager.currentUserId;
    if (userId != null) {
      await getIt<NotificationReadCursorBusiness>().syncReadCursors(
        userId,
        [category],
      );
    }

    final updated = Map<String, int>.from(state.unreadByCategory);
    updated[category] = 0;
    emit(
      state.copyWith(
        unreadByCategory: updated,
        unreadCount: updated.values.fold<int>(0, (sum, count) => sum + count),
      ),
    );
  }

  NotificationInboxBusiness get business => _inboxBusiness;
}
