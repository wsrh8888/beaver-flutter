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
import 'package:beaver/features/group/list/bloc/event.dart';
import 'package:beaver/features/group/list/bloc/state.dart';
import 'package:beaver/features/group/list/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('group-list');

class GroupListBloc extends Bloc<GroupListEvent, GroupListState> {
  final GroupListRepository _groupListRepository;

  GroupListBloc({GroupListRepository? groupListRepository}) 
    : _groupListRepository = groupListRepository ?? GroupListRepository(),
      super(const GroupListState()) {
    on<LoadGroupListEvent>(_onLoadGroupList);
    on<SelectGroupEvent>(_onSelectGroup);
    on<CreateGroupEvent>(_onCreateGroup);
  }

  Future<void> _onLoadGroupList(
    LoadGroupListEvent event,
    Emitter<GroupListState> emit,
  ) async {
    emit(state.copyWith(status: GroupListStatus.loading));
    _logger.info({'text': '加载群聊列表'});

    try {
      final groupList = await _groupListRepository.getGroupList();
      _logger.info({
        'text': '加载群聊列表成功',
        'data': {'count': groupList?.length ?? 0},
      });
      emit(state.copyWith(
        status: GroupListStatus.success,
        groupList: groupList ?? [],
      ));
    } catch (e) {
      _logger.error({
        'text': '加载群聊列表失败',
        'data': {'error': e.toString()},
      });
      emit(state.copyWith(
        status: GroupListStatus.error,
        errorMessage: '加载群聊列表失败: $e',
      ));
    }
  }

  Future<void> _onSelectGroup(
    SelectGroupEvent event,
    Emitter<GroupListState> emit,
  ) async {
    // 导航到群聊页?
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupListState> emit,
  ) async {
    // 导航到创建群聊页?
  }
}

