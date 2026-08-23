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
import 'package:beaver/features/chat/list/bloc/event.dart';
import 'package:beaver/features/chat/list/bloc/state.dart';
import 'package:beaver/features/chat/list/data/repositories/repository.dart';
import 'package:beaver/types/business/chat.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatListRepository _chatListRepository;

  ChatListBloc({ChatListRepository? chatListRepository}) 
    : _chatListRepository = chatListRepository ?? ChatListRepository(),
      super(const ChatListState()) {
    on<LoadChatListEvent>(_onLoadChatList);
    on<TogglePinChatEvent>(_onTogglePinChat);
    on<DeleteChatEvent>(_onDeleteChat);
    on<ChatListUpdatedEvent>(_onChatListUpdated);
  }

  Future<void> _onLoadChatList(
    LoadChatListEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(status: ChatListStatus.loading));

    try {
      final chats = await _chatListRepository.getChatList();
    final pinnedChats = chats.where((c) => c.isTop).toList();
    final regularChats = chats.where((c) => !c.isTop).toList();

    emit(state.copyWith(
      status: ChatListStatus.success,
      chats: regularChats as List<ChatModel>?,
      pinnedChats: pinnedChats as List<ChatModel>?,
    ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatListStatus.error,
        errorMessage: '加载聊天列表失败: $e',
      ));
    }
  }

  Future<void> _onTogglePinChat(
    TogglePinChatEvent event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      await _chatListRepository.togglePinChat(event.conversationId, event.isPinned);
      add(const LoadChatListEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ChatListStatus.error,
        errorMessage: '置顶操作失败: $e',
      ));
    }
  }

  Future<void> _onDeleteChat(
    DeleteChatEvent event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      await _chatListRepository.deleteChat(event.conversationId);
      add(const LoadChatListEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ChatListStatus.error,
        errorMessage: '删除会话失败: $e',
      ));
    }
  }

  void _onChatListUpdated(
    ChatListUpdatedEvent event,
    Emitter<ChatListState> emit,
  ) {
    final pinnedChats = event.chats.where((c) => c.isTop).toList();
    final regularChats = event.chats.where((c) => !c.isTop).toList();

    emit(state.copyWith(
      status: ChatListStatus.success,
      chats: regularChats as List<ChatModel>?,
      pinnedChats: pinnedChats as List<ChatModel>?,
    ));
  }
}
