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
import 'package:beaver/features/user/config/bloc/event.dart';
import 'package:beaver/features/user/config/bloc/state.dart';
import 'package:beaver/features/user/config/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('user-config');

class UserConfigBloc extends Bloc<UserConfigEvent, UserConfigState> {
  final UserConfigRepository _repository;

  UserConfigBloc(this._repository) : super(const UserConfigState()) {
    on<LoadFriendInfoEvent>(_onLoadFriendInfo);
    on<ToggleTopChatEvent>(_onToggleTopChat);
    on<ShowDeleteModalEvent>(_onShowDeleteModal);
    on<HideDeleteModalEvent>(_onHideDeleteModal);
    on<ConfirmDeleteEvent>(_onConfirmDelete);
  }

  Future<void> _onLoadFriendInfo(
    LoadFriendInfoEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    emit(state.copyWith(
      status: UserConfigStatus.loading,
      conversationId: event.conversationId,
    ));
    _logger.info({'text': '加载好友配置', 'data': {'conversationId': event.conversationId}});
    try {
      final info = await _repository.getFriendInfo(event.conversationId);
      _logger.info({'text': '加载好友配置成功', 'data': {'conversationId': event.conversationId}});
      emit(state.copyWith(
        status: UserConfigStatus.success,
        friendInfo: info,
      ));
    } catch (e) {
      _logger.error({
        'text': '加载好友配置失败',
        'data': {'conversationId': event.conversationId, 'error': e.toString()},
      });
      emit(state.copyWith(
        status: UserConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleTopChat(
    ToggleTopChatEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    final oldStatus = state.isTopChat;
    final newStatus = !oldStatus;
    _logger.info({
      'text': '切换置顶聊天',
      'data': {'conversationId': state.conversationId, 'newStatus': newStatus},
    });
    emit(state.copyWith(isTopChat: newStatus));

    try {
      final success = await _repository.toggleTopChat(state.conversationId, newStatus);
      if (!success) {
        _logger.warn({'text': '切换置顶聊天失败，已回滚', 'data': {'conversationId': state.conversationId}});
        emit(state.copyWith(isTopChat: oldStatus, errorMessage: '操作失败'));
      }
    } catch (e) {
      _logger.error({'text': '切换置顶聊天异常', 'data': {'error': e.toString()}});
      emit(state.copyWith(isTopChat: oldStatus, errorMessage: e.toString()));
    }
  }

  void _onShowDeleteModal(
    ShowDeleteModalEvent event,
    Emitter<UserConfigState> emit,
  ) {
    emit(state.copyWith(showDeleteModal: true));
  }

  void _onHideDeleteModal(
    HideDeleteModalEvent event,
    Emitter<UserConfigState> emit,
  ) {
    emit(state.copyWith(showDeleteModal: false));
  }

  Future<void> _onConfirmDelete(
    ConfirmDeleteEvent event,
    Emitter<UserConfigState> emit,
  ) async {
    if (state.friendInfo == null) return;
    final userId = state.friendInfo!.userId;

    emit(state.copyWith(status: UserConfigStatus.loading));
    _logger.info({'text': '删除好友', 'data': {'userId': userId}});
    try {
      final success = await _repository.deleteFriend(userId);
      if (success) {
        _logger.info({'text': '删除好友成功', 'data': {'userId': userId}});
        emit(state.copyWith(showDeleteModal: false, status: UserConfigStatus.success));
      } else {
        _logger.warn({'text': '删除好友失败', 'data': {'userId': userId}});
        emit(state.copyWith(
          status: UserConfigStatus.error,
          errorMessage: '删除失败',
        ));
      }
    } catch (e) {
      _logger.error({'text': '删除好友异常', 'data': {'userId': userId, 'error': e.toString()}});
      emit(state.copyWith(
        status: UserConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
