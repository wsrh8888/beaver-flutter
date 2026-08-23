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

import 'package:beaver/api/chat.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'picker_event.dart';
import 'picker_state.dart';

class ForwardPickerBloc extends Bloc<ForwardPickerEvent, ForwardPickerState> {
  final List<String> messageIds;
  final int forwardMode;
  final ContactStore contactStore;

  ForwardPickerBloc({
    required this.messageIds,
    required this.forwardMode,
    required this.contactStore,
  }) : super(const ForwardPickerState()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<ExecuteForwardEvent>(_onExecuteForward);

    // 初始加载联系人
    add(const LoadContactsEvent());
  }

  void _onLoadContacts(LoadContactsEvent event, Emitter<ForwardPickerState> emit) {
    emit(state.copyWith(status: ForwardPickerStatus.loading));
    
    // 从全局 Store 获取联系人数据
    var contacts = contactStore.state.userMap.values.toList();
    
    // 简单的关键词搜索过滤
    if (event.query != null && event.query!.isNotEmpty) {
      contacts = contacts.where((u) => 
        u.nickname.contains(event.query!)
      ).toList();
    }

    emit(state.copyWith(status: ForwardPickerStatus.success, contacts: contacts));
  }

  Future<void> _onExecuteForward(ExecuteForwardEvent event, Emitter<ForwardPickerState> emit) async {
    emit(state.copyWith(status: ForwardPickerStatus.executing));

    final res = await forwardMessageApi(IForwardMessageReq(
      messageIds: messageIds,
      targetId: event.targetId,
      forwardMode: forwardMode,
      forwardType: event.forwardType,
    ));

    if (res.code == 0) {
      emit(state.copyWith(status: ForwardPickerStatus.completed));
    } else {
      emit(state.copyWith(status: ForwardPickerStatus.failure, error: res.msg));
    }
  }
}
