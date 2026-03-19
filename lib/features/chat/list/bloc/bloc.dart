import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/chat/list/bloc/event.dart';
import 'package:beaver/features/chat/list/bloc/state.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/chat.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final _conversationBusiness = getIt<ConversationBusiness>();

  ChatListBloc() : super(const ChatListState()) {
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
      final chats = await _conversationBusiness.getChatList();
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
      await _conversationBusiness.togglePinChat(event.conversationId, event.isPinned);
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
      await _conversationBusiness.deleteChat(event.conversationId);
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
