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

import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/group.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupStoreState extends Equatable {
  final Map<String, GroupInfo> groupMap;
  final int version;

  const GroupStoreState({
    this.groupMap = const {},
    this.version = 0,
  });

  GroupStoreState copyWith({
    Map<String, GroupInfo>? groupMap,
    int? version,
  }) {
    return GroupStoreState(
      groupMap: groupMap ?? this.groupMap,
      version: version ?? this.version,
    );
  }

  List<GroupInfo> get groupList => groupMap.values.toList();

  @override
  List<Object?> get props => [groupMap, version];
}

class GroupStore extends Cubit<GroupStoreState> {
  final GroupBusiness _groupBusiness;
  StreamSubscription? _groupBusinessSubscription;
  Timer? _groupUpdateDebounceTimer;
  final Set<String> _pendingGroupIds = <String>{};

  GroupStore({GroupBusiness? groupBusiness})
      : _groupBusiness = groupBusiness ?? getIt<GroupBusiness>(),
        super(const GroupStoreState()) {
    _groupBusinessSubscription = _groupBusiness.groupUpdateStream.listen((ids) {
      _pendingGroupIds.addAll(ids.where((id) => id.trim().isNotEmpty));
      _groupUpdateDebounceTimer?.cancel();
      _groupUpdateDebounceTimer = Timer(const Duration(milliseconds: 200), () {
        final pending = _pendingGroupIds.toList(growable: false);
        _pendingGroupIds.clear();
        updateGroupsByIds(pending);
      });
    });
  }

  @override
  Future<void> close() {
    _groupBusinessSubscription?.cancel();
    _groupUpdateDebounceTimer?.cancel();
    return super.close();
  }

  Future<void> init() async {
    final groups = await _groupBusiness.getGroupList();
    final nextMap = <String, GroupInfo>{};
    if (groups != null) {
      for (final group in groups) {
        nextMap[group.conversationId] = group;
      }
    }
    emit(state.copyWith(groupMap: nextMap, version: state.version + 1));
  }

  Future<void> updateGroupsByIds(List<String> groupIds) async {
    if (groupIds.isEmpty) return;

    final groups = await _groupBusiness.getGroupsByIds(groupIds);
    final nextMap = Map<String, GroupInfo>.from(state.groupMap);
    var changed = false;

    final activeIds = <String>{};
    for (final group in groups) {
      final groupId = group.conversationId.replaceFirst('group_', '');
      activeIds.add(groupId);
      final key = group.conversationId;
      if (nextMap[key] != group) {
        nextMap[key] = group;
        changed = true;
      }
    }

    for (final groupId in groupIds) {
      if (!activeIds.contains(groupId) && nextMap.remove('group_$groupId') != null) {
        changed = true;
      }
    }

    if (changed) {
      emit(state.copyWith(groupMap: nextMap, version: state.version + 1));
    }
  }

  void removeGroup(String groupIdOrConversationId) {
    final conversationId = groupIdOrConversationId.startsWith('group_')
        ? groupIdOrConversationId
        : 'group_$groupIdOrConversationId';
    if (!state.groupMap.containsKey(conversationId)) {
      return;
    }
    final nextMap = Map<String, GroupInfo>.from(state.groupMap)
      ..remove(conversationId);
    emit(state.copyWith(groupMap: nextMap, version: state.version + 1));
  }

  GroupInfo? getGroup(String groupId) {
    if (groupId.startsWith('group_')) {
      return state.groupMap[groupId];
    }
    return state.groupMap['group_$groupId'];
  }
}
