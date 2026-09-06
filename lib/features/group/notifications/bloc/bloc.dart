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
import 'package:beaver/features/group/notifications/bloc/event.dart';
import 'package:beaver/features/group/notifications/bloc/state.dart';
import 'package:beaver/types/business/group.dart';
import 'package:beaver/features/group/notifications/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('group-notifications');

class GroupNotificationsBloc extends Bloc<GroupNotificationsEvent, GroupNotificationsState> {
  final GroupNotificationRepository _repository = GroupNotificationRepository();

  GroupNotificationsBloc() : super(const GroupNotificationsState()) {
    on<LoadGroupNotificationsEvent>(_onLoadNotifications);
    on<SwitchTabEvent>(_onSwitchTab);
    on<AcceptGroupRequestEvent>(_onAcceptRequest);
    on<RejectGroupRequestEvent>(_onRejectRequest);
  }

  Future<void> _onLoadNotifications(
    LoadGroupNotificationsEvent event,
    Emitter<GroupNotificationsState> emit,
  ) async {
    emit(state.copyWith(status: GroupNotificationsStatus.loading));
    _logger.info({'text': '加载群通知列表'});
    try {
      final notifications = await _repository.getGroupNotifications();
      emit(state.copyWith(
        status: GroupNotificationsStatus.success,
        notifications: notifications,
      ));
      _logger.info({
        'text': '群通知列表加载完成',
        'data': {'count': notifications.length},
      });
    } catch (e) {
      _logger.error({
        'text': '加载群通知列表失败',
        'data': {'error': e.toString()},
      });
      emit(state.copyWith(
        status: GroupNotificationsStatus.error,
        errorMessage: '加载群通知失败: $e',
      ));
    }
  }

  Future<void> _onSwitchTab(SwitchTabEvent event, Emitter<GroupNotificationsState> emit) async {
    emit(state.copyWith(activeTab: event.tab));
  }

  Future<void> _onAcceptRequest(AcceptGroupRequestEvent event, Emitter<GroupNotificationsState> emit) async {
    emit(state.copyWith(status: GroupNotificationsStatus.loading));
    _logger.info({'text': '同意入群申请', 'data': {'id': event.id}});
    try {
      await _repository.updateRequestStatus(event.id, 1);
      final updated = state.notifications.map<GroupNotification>((n) {
        if (n.id == event.id) {
          return GroupNotification(
            id: n.id,
            groupId: n.groupId,
            groupName: n.groupName,
            groupAvatar: n.groupAvatar,
            applicantUserId: n.applicantUserId,
            applicantNickname: n.applicantNickname,
            applicantAvatar: n.applicantAvatar,
            message: n.message,
            status: 1,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();
      emit(state.copyWith(status: GroupNotificationsStatus.success, notifications: updated));
      _logger.info({'text': '入群申请已同意', 'data': {'id': event.id}});
    } catch (e) {
      _logger.error({
        'text': '同意入群申请失败',
        'data': {'id': event.id, 'error': e.toString()},
      });
      emit(state.copyWith(status: GroupNotificationsStatus.error, errorMessage: '处理失败: $e'));
    }
  }

  Future<void> _onRejectRequest(RejectGroupRequestEvent event, Emitter<GroupNotificationsState> emit) async {
    emit(state.copyWith(status: GroupNotificationsStatus.loading));
    _logger.info({'text': '拒绝入群申请', 'data': {'id': event.id}});
    try {
      await _repository.updateRequestStatus(event.id, 2);
      final updated = state.notifications.map<GroupNotification>((n) {
        if (n.id == event.id) {
          return GroupNotification(
            id: n.id,
            groupId: n.groupId,
            groupName: n.groupName,
            groupAvatar: n.groupAvatar,
            applicantUserId: n.applicantUserId,
            applicantNickname: n.applicantNickname,
            applicantAvatar: n.applicantAvatar,
            message: n.message,
            status: 2,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();
      emit(state.copyWith(status: GroupNotificationsStatus.success, notifications: updated));
      _logger.info({'text': '入群申请已拒绝', 'data': {'id': event.id}});
    } catch (e) {
      _logger.error({
        'text': '拒绝入群申请失败',
        'data': {'id': event.id, 'error': e.toString()},
      });
      emit(state.copyWith(status: GroupNotificationsStatus.error, errorMessage: '处理失败: $e'));
    }
  }
}
