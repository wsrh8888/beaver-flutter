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
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/types/business/contact.dart';
import 'event.dart';
import 'state.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('contact-selector');

class ContactSelectorBloc extends Bloc<ContactSelectorEvent, ContactSelectorState> {
  final FriendStore _friendStore;
  StreamSubscription? _friendSubscription;

  ContactSelectorBloc({
    FriendStore? friendStore,
    List<ContactModel> initialSelected = const [],
  }) : _friendStore = friendStore ?? getIt<FriendStore>(),
       super(ContactSelectorState(selectedContacts: initialSelected)) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<SelectContactEvent>(_onSelectContact);
    on<SearchContactsEvent>(_onSearchContacts);

    _friendSubscription = _friendStore.stream.listen((_) {
      add(const LoadContactsEvent());
    });
    
    add(const LoadContactsEvent());
  }

  @override
  Future<void> close() {
    _friendSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<ContactSelectorState> emit,
  ) async {
    final contacts = _friendStore.state.friends;
    _logger.info({'text': '加载可选联系人', 'data': {'count': contacts.length}});
    emit(state.copyWith(status: ContactSelectorStatus.success, contacts: contacts));
  }

  Future<void> _onSelectContact(
    SelectContactEvent event,
    Emitter<ContactSelectorState> emit,
  ) async {
    final selectedContacts = List<ContactModel>.from(state.selectedContacts);
    final index = selectedContacts.indexWhere(
      (c) => c.userId == event.contact.userId,
    );

    final isSelect = index == -1;
    if (isSelect) {
      selectedContacts.add(event.contact);
    } else {
      selectedContacts.removeAt(index);
    }
    _logger.info({
      'text': isSelect ? '选中联系人' : '取消选中联系人',
      'data': {'userId': event.contact.userId, 'selectedCount': selectedContacts.length},
    });

    emit(state.copyWith(selectedContacts: selectedContacts));
  }

  Future<void> _onSearchContacts(
    SearchContactsEvent event,
    Emitter<ContactSelectorState> emit,
  ) async {
    _logger.info({'text': '搜索联系人', 'data': {'query': event.query}});
    emit(state.copyWith(searchQuery: event.query));
  }
}
