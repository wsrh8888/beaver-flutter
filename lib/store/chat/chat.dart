import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/types/business/chat.dart';

class ChatStoreState extends Equatable {
  final List<ChatModel> conversations;
  final int totalUnreadCount;

  const ChatStoreState({
    this.conversations = const [],
    this.totalUnreadCount = 0,
  });

  ChatStoreState copyWith({
    List<ChatModel>? conversations,
    int? totalUnreadCount,
  }) {
    return ChatStoreState(
      conversations: conversations ?? this.conversations,
      totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
    );
  }

  @override
  List<Object?> get props => [conversations, totalUnreadCount];
}

class ChatStore extends Cubit<ChatStoreState> {
  final ConversationBusiness _conversationBusiness;
  
  ChatStore({ConversationBusiness? conversationBusiness}) 
    : _conversationBusiness = conversationBusiness ?? getIt<ConversationBusiness>(),
      super(const ChatStoreState());

  /**
   * @description: 初始化会话列表与未读数
   */
  Future<void> init() async {
    try {
      final conversations = await _conversationBusiness.getChatList();
      
      // 计算总未读数
      int totalUnread = 0;
      for (var conv in conversations) {
        totalUnread += conv.unreadCount;
      }

      emit(state.copyWith(
        conversations: conversations,
        totalUnreadCount: totalUnread,
      ));
    } catch (e) {
      print('ChatStore: 初始化失败: $e');
    }
  }

  void updateTotalUnreadCount(int count) {
    emit(state.copyWith(totalUnreadCount: count));
  }
}
