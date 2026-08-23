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
import 'package:beaver/features/group/member/bloc/event.dart';
import 'package:beaver/features/group/member/bloc/state.dart';
import 'package:beaver/features/group/member/data/repositories/repository.dart';

class GroupMemberBloc extends Bloc<GroupMemberEvent, GroupMemberState> {
  final GroupMemberRepository _repository;
  String _currentUserId = '1';

  GroupMemberBloc(this._repository) : super(const GroupMemberState()) {
    on<LoadGroupMembersEvent>(_onLoadGroupMembers);
    on<ToggleSelectEvent>(_onToggleSelect);
    on<ConfirmAddEvent>(_onConfirmAdd);
    on<ConfirmRemoveEvent>(_onConfirmRemove);
  }

  Future<void> _onLoadGroupMembers(
    LoadGroupMembersEvent event,
    Emitter<GroupMemberState> emit,
  ) async {
    emit(state.copyWith(
      status: GroupMemberStatus.loading,
      groupId: event.groupId,
      mode: event.mode,
    ));

    try {
      final groupMembers = await _repository.getGroupMembers(event.groupId);
      final contacts = await _repository.getContacts();
      emit(state.copyWith(
        status: GroupMemberStatus.success,
        groupMembers: groupMembers,
        contacts: contacts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupMemberStatus.error,
        errorMessage: '加载群成员失�? $e',
      ));
    }
  }

  Future<void> _onToggleSelect(
    ToggleSelectEvent event,
    Emitter<GroupMemberState> emit,
  ) async {
    final updatedSelectedIds = List<String>.from(state.selectedIds);
    if (updatedSelectedIds.contains(event.userId)) {
      updatedSelectedIds.remove(event.userId);
    } else {
      updatedSelectedIds.add(event.userId);
    }
    emit(state.copyWith(selectedIds: updatedSelectedIds));
  }

  Future<void> _onConfirmAdd(
    ConfirmAddEvent event,
    Emitter<GroupMemberState> emit,
  ) async {
    if (state.selectedIds.isEmpty) {
      emit(state.copyWith(
        errorMessage: '请选择要添加的成员',
      ));
      return;
    }

    emit(state.copyWith(status: GroupMemberStatus.loading));

    try {
      await _repository.addGroupMembers(state.groupId, state.selectedIds);
      emit(state.copyWith(
        status: GroupMemberStatus.success,
        selectedIds: [],
        errorMessage: '添加成员成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupMemberStatus.error,
        errorMessage: '添加成员失败: $e',
      ));
    }
  }

  Future<void> _onConfirmRemove(
    ConfirmRemoveEvent event,
    Emitter<GroupMemberState> emit,
  ) async {
    if (state.selectedIds.isEmpty) {
      emit(state.copyWith(
        errorMessage: '请选择要移除的成员',
      ));
      return;
    }

    emit(state.copyWith(status: GroupMemberStatus.loading));

    try {
      await _repository.removeGroupMembers(state.groupId, state.selectedIds);
      emit(state.copyWith(
        status: GroupMemberStatus.success,
        selectedIds: [],
        errorMessage: '移除成员成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupMemberStatus.error,
        errorMessage: '移除成员失败: $e',
      ));
    }
  }
}

