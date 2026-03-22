import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/chat.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    : _conversationBusiness =
          conversationBusiness ?? getIt<ConversationBusiness>(),
      super(const ChatStoreState());

  Future<void> init() async {
    try {
      final conversations = await _conversationBusiness.getChatList();
      print('[ChatStore] init: businessConversations=${conversations.length}');
      for (final conv in conversations) {
        print(
          '[ChatStore][BUSINESS] id=${conv.conversationId}, '
          'nickname=${conv.nickname}, avatar=${conv.avatar}, '
          'msgPreview=${conv.msgPreview}, isTop=${conv.isTop}, unread=${conv.unreadCount}',
        );
      }

      var totalUnread = 0;
      for (final conv in conversations) {
        totalUnread += conv.unreadCount;
      }

      final nextState = state.copyWith(
        conversations: conversations,
        totalUnreadCount: totalUnread,
      );
      emit(nextState);

      print(
        '[ChatStore] init: emitted conversations=${nextState.conversations.length}, '
        'totalUnread=${nextState.totalUnreadCount}',
      );
      for (final conv in nextState.conversations) {
        print(
          '[ChatStore][STATE] id=${conv.conversationId}, '
          'nickname=${conv.nickname}, avatar=${conv.avatar}, '
          'msgPreview=${conv.msgPreview}, isTop=${conv.isTop}, unread=${conv.unreadCount}',
        );
      }
    } catch (e) {
      print('ChatStore: init failed: $e');
    }
  }

  Future<void> togglePinChat(String conversationId, bool isPinned) async {
    await _conversationBusiness.togglePinChat(conversationId, isPinned);
    await init();
  }

  Future<void> deleteChat(String conversationId) async {
    await _conversationBusiness.deleteChat(conversationId);
    await init();
  }

  void updateTotalUnreadCount(int count) {
    emit(state.copyWith(totalUnreadCount: count));
  }
}
