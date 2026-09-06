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
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('message');

class MessagePagination extends Equatable {
  final bool hasMore;
  final bool isLoadingMore;
  final int offset;

  const MessagePagination({
    this.hasMore = true,
    this.isLoadingMore = false,
    this.offset = 0,
  });

  MessagePagination copyWith({
    bool? hasMore,
    bool? isLoadingMore,
    int? offset,
  }) {
    return MessagePagination(
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [hasMore, isLoadingMore, offset];
}

class MessageStoreState extends Equatable {
  final Map<String, List<MessageModel>> chatHistory;
  final Map<String, MessagePagination> messagePagination;
  final int version;

  const MessageStoreState({
    this.chatHistory = const {},
    this.messagePagination = const {},
    this.version = 0,
  });

  MessageStoreState copyWith({
    Map<String, List<MessageModel>>? chatHistory,
    Map<String, MessagePagination>? messagePagination,
    int? version,
  }) {
    return MessageStoreState(
      chatHistory: chatHistory ?? this.chatHistory,
      messagePagination: messagePagination ?? this.messagePagination,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [chatHistory, messagePagination, version];
}

class MessageStore extends Cubit<MessageStoreState> {
  final MessageBusiness _messageBusiness;
  static const int PAGE_SIZE = 30;

  MessageStore({MessageBusiness? messageBusiness})
    : _messageBusiness = messageBusiness ?? getIt<MessageBusiness>(),
      super(const MessageStoreState());

  Future<void> init() async {}

  /**
   * @description: 初始化会话消息（类似 PC 端 init）
   */
  Future<void> initConversation(String conversationId) async {
    _logger.info({
      'text': '初始化会话消息',
      'data': {'conversationId': conversationId},
    });
    if (state.chatHistory.containsKey(conversationId) &&
        state.chatHistory[conversationId]!.isNotEmpty) {
      _logger.info({
        'text': '会话消息已加载，跳过初始化',
        'data': {'conversationId': conversationId},
      });
      return;
    }

    await reloadConversation(conversationId);
  }

  /// 从本地 DB 重新加载会话消息（后台同步后刷新已打开会话）
  Future<void> reloadConversation(String conversationId) async {
    _logger.info({
      'text': '重新加载会话消息',
      'data': {'conversationId': conversationId, 'pageSize': PAGE_SIZE},
    });
    final pagination = MessagePagination(
      hasMore: true,
      isLoadingMore: true,
      offset: 0,
    );

    _updatePagination(conversationId, pagination);

    try {
      final messages = await _messageBusiness.getMessages(
        conversationId,
        limit: PAGE_SIZE,
        offset: 0,
      );

      final newHistory = Map<String, List<MessageModel>>.from(
        state.chatHistory,
      );
      newHistory[conversationId] = messages;

      final newPagination = Map<String, MessagePagination>.from(
        state.messagePagination,
      );
      newPagination[conversationId] = MessagePagination(
        hasMore: messages.length >= PAGE_SIZE,
        isLoadingMore: false,
        offset: messages.length,
      );

      emit(
        state.copyWith(
          chatHistory: newHistory,
          messagePagination: newPagination,
          version: state.version + 1,
        ),
      );
      _logger.info({
        'text': '会话消息加载完成',
        'data': {
          'conversationId': conversationId,
          'count': messages.length,
          'hasMore': messages.length >= PAGE_SIZE,
        },
      });
    } catch (e) {
      _updatePagination(
        conversationId,
        pagination.copyWith(isLoadingMore: false),
      );
      _logger.error({
        'text': '重新加载会话消息失败',
        'data': {'conversationId': conversationId, 'error': e.toString()},
      });
      rethrow;
    }
  }

  /**
   * @description: 加载更多历史消息
   */
  Future<void> loadMore(String conversationId) async {
    final pagination =
        state.messagePagination[conversationId] ?? const MessagePagination();
    if (!pagination.hasMore || pagination.isLoadingMore) {
      _logger.info({
        'text': '跳过加载更多',
        'data': {
          'conversationId': conversationId,
          'hasMore': pagination.hasMore,
          'isLoadingMore': pagination.isLoadingMore,
        },
      });
      return;
    }

    _logger.info({
      'text': '开始加载更多历史消息',
      'data': {
        'conversationId': conversationId,
        'offset': pagination.offset,
        'pageSize': PAGE_SIZE,
      },
    });
    _updatePagination(conversationId, pagination.copyWith(isLoadingMore: true));

    try {
      final messages = await _messageBusiness.getMessages(
        conversationId,
        limit: PAGE_SIZE,
        offset: pagination.offset,
      );

      final history = List<MessageModel>.from(
        state.chatHistory[conversationId] ?? [],
      );
      // 去重：只添加 history 中不存在的消息
      final existingIds = history.map((m) => m.id).toSet();
      final newMessages = messages.where((m) => !existingIds.contains(m.id)).toList();

      if (newMessages.isEmpty && messages.isNotEmpty) {
        _logger.warn({
          'text': '加载更多消息全部重复，停止递归',
          'data': {
            'conversationId': conversationId,
            'count': messages.length,
          },
        });
      }

      history.addAll(newMessages);

      final newHistory = Map<String, List<MessageModel>>.from(
        state.chatHistory,
      );
      newHistory[conversationId] = history;

      final newPagination = Map<String, MessagePagination>.from(
        state.messagePagination,
      );
      newPagination[conversationId] = MessagePagination(
        hasMore: messages.length >= PAGE_SIZE,
        isLoadingMore: false,
        offset: pagination.offset + messages.length,
      );

      emit(
        state.copyWith(
          chatHistory: newHistory,
          messagePagination: newPagination,
          version: state.version + 1,
        ),
      );
      _logger.info({
        'text': '加载更多历史消息完成',
        'data': {
          'conversationId': conversationId,
          '新增': newMessages.length,
          'hasMore': messages.length >= PAGE_SIZE,
          'newOffset': pagination.offset + messages.length,
        },
      });
    } catch (e) {
      _updatePagination(
        conversationId,
        pagination.copyWith(isLoadingMore: false),
      );
      _logger.error({
        'text': '加载更多历史消息失败',
        'data': {'conversationId': conversationId, 'error': e.toString()},
      });
      rethrow;
    }
  }

  /**
   * @description: 实时添加消息
   */
  void addMessage(String conversationId, MessageModel message) {
    _logger.info({
      'text': '新增消息到会话',
      'data': {'conversationId': conversationId, 'messageId': message.id},
    });
    final history = List<MessageModel>.from(
      state.chatHistory[conversationId] ?? [],
    );

    // 更加健壮的去重逻辑：优先通过 ID 匹配
    final index = history.indexWhere((m) => m.id == message.id);

    bool isNew = false;
    if (index != -1) {
      _logger.info({
        'text': '按ID匹配更新已存在消息',
        'data': {'conversationId': conversationId, 'messageId': message.id},
      });
      history[index] = message;
    } else {
      final stringIndex = history.indexWhere(
        (m) => m.id.toString() == message.id.toString(),
      );
      if (stringIndex != -1) {
        _logger.info({
          'text': '按字符串ID匹配更新已存在消息',
          'data': {'conversationId': conversationId, 'messageId': message.id},
        });
        history[stringIndex] = message;
      } else {
        _logger.info({
          'text': '插入新消息',
          'data': {'conversationId': conversationId, 'messageId': message.id},
        });
        history.insert(0, message);
        isNew = true;
      }
    }

    final newHistory = Map<String, List<MessageModel>>.from(state.chatHistory);
    newHistory[conversationId] = history;

    final newPagination = Map<String, MessagePagination>.from(
      state.messagePagination,
    );
    final pagination =
        newPagination[conversationId] ?? const MessagePagination();

    // 只有在插入新消息时才增加 offset，避免重复更新导致分页偏移
    if (isNew) {
      newPagination[conversationId] = pagination.copyWith(
        offset: pagination.offset + 1,
      );
    }

    emit(
      state.copyWith(
        chatHistory: newHistory,
        messagePagination: newPagination,
        version: state.version + 1,
      ),
    );
  }

  void _updatePagination(String conversationId, MessagePagination pagination) {
    final newPagination = Map<String, MessagePagination>.from(
      state.messagePagination,
    );
    newPagination[conversationId] = pagination;
    emit(
      state.copyWith(
        messagePagination: newPagination,
        version: state.version + 1,
      ),
    );
  }

  /// 更新消息内容（编辑后本地同步）
  void updateMessageContent(
    String conversationId,
    String messageId,
    MessageContentModel msg,
  ) {
    if (!state.chatHistory.containsKey(conversationId)) return;

    final history = state.chatHistory[conversationId]!
        .map((m) {
          if (m.id != messageId) return m;
          return m.copyWith(msg: msg, isEdited: true);
        })
        .toList();

    final newHistory = Map<String, List<MessageModel>>.from(state.chatHistory);
    newHistory[conversationId] = history;

    emit(
      state.copyWith(
        chatHistory: newHistory,
        version: state.version + 1,
      ),
    );
  }

  /// 批量移除消息（本地缓存 + UI）
  void removeMessages(String conversationId, List<String> messageIds) {
    if (messageIds.isEmpty || !state.chatHistory.containsKey(conversationId)) {
      return;
    }

    final history = state.chatHistory[conversationId]!
        .where((m) => !messageIds.contains(m.id))
        .toList();

    final newHistory = Map<String, List<MessageModel>>.from(state.chatHistory);
    newHistory[conversationId] = history;

    emit(
      state.copyWith(
        chatHistory: newHistory,
        version: state.version + 1,
      ),
    );
  }

  /**
   * @description: 清空会话消息缓存
   */
  void clearConversationMessages(String conversationId) {
    if (!state.chatHistory.containsKey(conversationId)) return;

    final newHistory = Map<String, List<MessageModel>>.from(state.chatHistory);
    newHistory.remove(conversationId);

    final newPagination = Map<String, MessagePagination>.from(
      state.messagePagination,
    );
    newPagination.remove(conversationId);

    emit(
      state.copyWith(
        chatHistory: newHistory,
        messagePagination: newPagination,
        version: state.version + 1,
      ),
    );
  }

  MessageBusiness get business => _messageBusiness;
}
