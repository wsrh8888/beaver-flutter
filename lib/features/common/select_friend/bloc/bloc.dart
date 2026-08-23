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

    if (index == -1) {
      selectedContacts.add(event.contact);
    } else {
      selectedContacts.removeAt(index);
    }

    emit(state.copyWith(selectedContacts: selectedContacts));
  }

  Future<void> _onSearchContacts(
    SearchContactsEvent event,
    Emitter<ContactSelectorState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
  }
}
