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
import 'package:beaver/features/group/config/bloc/event.dart';
import 'package:beaver/features/group/config/bloc/state.dart';
import 'package:beaver/features/group/config/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('group-config');

class GroupConfigBloc extends Bloc<GroupConfigEvent, GroupConfigState> {
  final GroupConfigRepository _repository;

  GroupConfigBloc(this._repository) : super(const GroupConfigState()) {
    on<LoadGroupInfoEvent>(_onLoadGroupInfo);
    on<UpdateGroupNameEvent>(_onUpdateGroupName);
    on<ExitGroupEvent>(_onExitGroup);
  }

  Future<void> _onLoadGroupInfo(
    LoadGroupInfoEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    emit(state.copyWith(status: GroupConfigStatus.loading));
    _logger.info({'text': '加载群信息', 'data': {'groupId': event.groupId}});
    try {
      final info = await _repository.getGroupInfo(event.groupId);
      final members = await _repository.getGroupMembers(event.groupId);
      _logger.info({
        'text': '加载群信息成功',
        'data': {'groupId': event.groupId, 'memberCount': members.length},
      });
      emit(state.copyWith(
        status: GroupConfigStatus.success,
        groupInfo: info,
        groupName: info.title,
      ));
    } catch (e) {
      _logger.error({
        'text': '加载群信息失败',
        'data': {'groupId': event.groupId, 'error': e.toString()},
      });
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateGroupName(
    UpdateGroupNameEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    if (state.groupName.isEmpty) {
      _logger.warn({'text': '修改群名称为空'});
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: '群名称不能为空',
      ));
      return;
    }

    _logger.info({
      'text': '修改群名称',
      'data': {'groupId': state.groupInfo?.groupId, 'groupName': state.groupName},
    });
    try {
      final success = await _repository.updateGroupName(
        state.groupInfo!.groupId,
        state.groupName,
      );
      if (success) {
        _logger.info({'text': '群名称修改成功', 'data': {'groupId': state.groupInfo?.groupId}});
        emit(state.copyWith(
          status: GroupConfigStatus.success,
          errorMessage: '群名称修改成功',
        ));
      } else {
        _logger.warn({'text': '群名称修改失败', 'data': {'groupId': state.groupInfo?.groupId}});
        emit(state.copyWith(
          status: GroupConfigStatus.error,
          errorMessage: '修改失败',
        ));
      }
    } catch (e) {
      _logger.error({
        'text': '修改群名称异常',
        'data': {'error': e.toString()},
      });
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onExitGroup(
    ExitGroupEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    _logger.info({'text': '退出群聊', 'data': {'groupId': state.groupInfo?.groupId}});
    try {
      final success = await _repository.quitGroup(state.groupInfo!.groupId);
      if (success) {
        _logger.info({'text': '退出群聊成功', 'data': {'groupId': state.groupInfo?.groupId}});
        emit(state.copyWith(
          status: GroupConfigStatus.success,
          errorMessage: '已退出群聊',
        ));
      } else {
        _logger.warn({'text': '退出群聊失败', 'data': {'groupId': state.groupInfo?.groupId}});
        emit(state.copyWith(
          status: GroupConfigStatus.error,
          errorMessage: '退出失败',
        ));
      }
    } catch (e) {
      _logger.error({
        'text': '退出群聊异常',
        'data': {'error': e.toString()},
      });
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
