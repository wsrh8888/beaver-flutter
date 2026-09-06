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
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/group/create/bloc/event.dart';
import 'package:beaver/features/group/create/bloc/state.dart';
import 'package:beaver/features/group/create/data/repositories/repository.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('group-create');

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final CreateGroupRepository _createGroupRepository;
  final FriendStore _friendStore;
  StreamSubscription? _friendSubscription;

  CreateGroupBloc({
    CreateGroupRepository? createGroupRepository,
    FriendStore? friendStore,
  }) : _createGroupRepository =
           createGroupRepository ?? CreateGroupRepository(),
       _friendStore = friendStore ?? getIt<FriendStore>(),
       super(const CreateGroupState()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<SelectContactEvent>(_onSelectContact);
    on<SearchContactsEvent>(_onSearchContacts);
    on<CreateGroupSubmitEvent>(_onCreateGroup);

    // 响应式监听：好友列表变化时自动刷新 UI
    _friendSubscription = _friendStore.stream.listen((_) {
      add(const LoadContactsEvent());
    });
  }

  @override
  Future<void> close() {
    _friendSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    final contacts = _friendStore.state.friends;
    emit(state.copyWith(status: CreateGroupStatus.success, contacts: contacts));
  }

  Future<void> _onSelectContact(
    SelectContactEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    final selectedContacts = List<ContactModel>.from(state.selectedContacts);
    final index = selectedContacts.indexWhere(
      (c) => c.userId == event.contact.userId,
    );

    if (index == -1) {
      selectedContacts.add(event.contact);
    } else {
      selectedContacts.removeAt(index);
    }

    emit(state.copyWith(selectedContacts: selectedContacts));
  }

  Future<void> _onSearchContacts(
    SearchContactsEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onCreateGroup(
    CreateGroupSubmitEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    if (state.selectedContacts.isEmpty) {
      _logger.warn({'text': '创建群组被拦截：未选择联系人'});
      emit(
        state.copyWith(
          status: CreateGroupStatus.error,
          errorMessage: '请至少选择一个联系人',
        ),
      );
      return;
    }

    final userIds = state.selectedContacts.map((c) => c.userId).toList();
    _logger.info({
      'text': '开始创建群组',
      'data': {'memberCount': userIds.length, 'userIds': userIds},
    });
    emit(state.copyWith(status: CreateGroupStatus.loading));

    try {
      final groupId = await _createGroupRepository.createGroup(userIds);
      _logger.info({
        'text': '创建群组成功',
        'data': {'groupId': groupId, 'memberCount': userIds.length},
      });
      emit(state.copyWith(status: CreateGroupStatus.success, groupId: groupId));
    } catch (e) {
      _logger.error({
        'text': '创建群组失败',
        'data': {'userIds': userIds, 'error': e.toString()},
      });
      emit(
        state.copyWith(
          status: CreateGroupStatus.error,
          errorMessage: '创建群组失败: $e',
        ),
      );
    }
  }
}
