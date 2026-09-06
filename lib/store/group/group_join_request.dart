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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/group/group_join_request.dart';
import 'package:beaver/types/business/group.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('group-join-request');

class GroupJoinRequestStoreState extends Equatable {
  final List<GroupNotification> groupJoinRequests;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final int unreadCount;

  const GroupJoinRequestStoreState({
    this.groupJoinRequests = const [],
    this.totalCount = 0,
    this.currentPage = 1,
    this.pageSize = 20,
    this.unreadCount = 0,
  });

  GroupJoinRequestStoreState copyWith({
    List<GroupNotification>? groupJoinRequests,
    int? totalCount,
    int? currentPage,
    int? pageSize,
    int? unreadCount,
  }) {
    return GroupJoinRequestStoreState(
      groupJoinRequests: groupJoinRequests ?? this.groupJoinRequests,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
    groupJoinRequests,
    totalCount,
    currentPage,
    pageSize,
    unreadCount,
  ];
}

class GroupJoinRequestStore extends Cubit<GroupJoinRequestStoreState> {
  final GroupJoinRequestBusiness _groupJoinRequestBusiness;

  GroupJoinRequestStore({GroupJoinRequestBusiness? groupJoinRequestBusiness})
    : _groupJoinRequestBusiness = groupJoinRequestBusiness ?? getIt<GroupJoinRequestBusiness>(),
      super(const GroupJoinRequestStoreState());

  Future<void> init({int page = 1, int limit = 20}) async {
    try {
      final requests = await _groupJoinRequestBusiness.getGroupNotifications();
      final unreadCount = await _groupJoinRequestBusiness.getUnreadGroupNotificationCount();
      emit(state.copyWith(
        groupJoinRequests: requests,
        totalCount: requests.length,
        currentPage: page,
        pageSize: limit,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      _logger.error({
        'text': '群加入申请初始化失败',
        'data': {'page': page, 'error': e.toString()},
      });
    }
  }

  Future<void> handleRequest(int requestId, int status) async {
    _logger.info({
      'text': '处理群加入申请',
      'data': {'requestId': requestId, 'status': status},
    });
    try {
      await _groupJoinRequestBusiness.updateGroupRequestStatus(requestId, status);
      await refresh();
    } catch (e) {
      _logger.error({
        'text': '处理群申请失败',
        'data': {'requestId': requestId, 'error': e.toString()},
      });
    }
  }

  Future<void> refresh() async {
    await init(
      page: state.currentPage,
      limit: state.pageSize,
    );
  }

  Future<void> loadMore() async {
    if (state.groupJoinRequests.length >= state.totalCount) {
      return;
    }
    final nextPage = state.currentPage + 1;
    try {
      final requests = await _groupJoinRequestBusiness.getGroupNotifications();
      final newList = [...state.groupJoinRequests, ...requests];
      emit(state.copyWith(
        groupJoinRequests: newList,
        totalCount: requests.length,
        currentPage: nextPage,
      ));
    } catch (e) {
      _logger.error({
        'text': '群加入申请加载更多失败',
        'data': {'error': e.toString()},
      });
    }
  }
}
