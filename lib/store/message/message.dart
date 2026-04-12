import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/types/business/message.dart';

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
    // 如果已有数据，可以考虑是否静默刷新或直接使用
    if (state.chatHistory.containsKey(conversationId) &&
        state.chatHistory[conversationId]!.isNotEmpty) {
      return;
    }

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
      print('[MessageStore] initConversation: $conversationId loaded ${messages.length} messages (offset: 0)');

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
    } catch (e) {
      _updatePagination(
        conversationId,
        pagination.copyWith(isLoadingMore: false),
      );
      rethrow;
    }
  }

  /**
   * @description: 加载更多历史消息
   */
  Future<void> loadMore(String conversationId) async {
    final pagination =
        state.messagePagination[conversationId] ?? const MessagePagination();
    if (!pagination.hasMore || pagination.isLoadingMore) return;

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
        print('[MessageStore] loadMore: all ${messages.length} messages were duplicates, stopping recursion');
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
    } catch (e) {
      _updatePagination(
        conversationId,
        pagination.copyWith(isLoadingMore: false),
      );
      rethrow;
    }
  }

  /**
   * @description: 实时添加消息
   */
  void addMessage(String conversationId, MessageModel message) {
    final history = List<MessageModel>.from(
      state.chatHistory[conversationId] ?? [],
    );

    // 更加健壮的去重逻辑：优先通过 ID 匹配
    final index = history.indexWhere((m) => m.id == message.id);

    bool isNew = false;
    if (index != -1) {
      print(
        '[MessageStore] addMessage: updated existing message ${message.id} in $conversationId',
      );
      history[index] = message;
    } else {
      final stringIndex = history.indexWhere(
        (m) => m.id.toString() == message.id.toString(),
      );
      if (stringIndex != -1) {
        print(
          '[MessageStore] addMessage: updated existing message ${message.id} (string match) in $conversationId',
        );
        history[stringIndex] = message;
      } else {
        print(
          '[MessageStore] addMessage: inserting NEW message ${message.id} in $conversationId',
        );
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
