import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/chat/chat_page/bloc/event.dart';
import 'package:beaver/features/chat/chat_page/bloc/state.dart';
import 'package:beaver/features/chat/chat_page/data/repositories/repository.dart';
import 'package:beaver/core/database/database.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;
  final String _conversationId;
  int _offset = 0;
  static const int _limit = 50;

  ChatBloc({
    required ChatRepository repository,
    required String conversationId,
  })  : _repository = repository,
        _conversationId = conversationId,
        super(const ChatState()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<LoadMoreMessagesEvent>(_onLoadMoreMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<UpdateMessageStatusEvent>(_onUpdateMessageStatus);
    on<MessageReceivedEvent>(_onMessageReceived);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));

    try {
      _offset = 0;
      final messages = await _repository.getMessages(
        _conversationId,
        limit: _limit,
        offset: _offset,
      );
      final conversation = await _repository.getConversation(_conversationId);

      emit(state.copyWith(
        status: ChatStatus.success,
        messages: messages,
        conversation: conversation,
        hasMore: messages.length >= _limit,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: '加载消息失败: $e',
      ));
    }
  }

  Future<void> _onLoadMoreMessages(
    LoadMoreMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      _offset += _limit;
      final moreMessages = await _repository.getMessages(
        _conversationId,
        limit: _limit,
        offset: _offset,
      );

      final updatedMessages = [...state.messages, ...moreMessages];

      emit(state.copyWith(
        messages: updatedMessages,
        hasMore: moreMessages.length >= _limit,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: '加载更多消息失败: $e',
      ));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.sending));

    try {
      // 先创建一个临时消息模型用于UI显示
      final tempMessage = MessageModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: _conversationId,
        userId: 'current_user', // 假设当前用户
        content: event.content,
        type: event.type,
        status: MessageStatus.sending,
        createdAt: DateTime.now(),
        isSent: true,
      );

      // 立即更新UI，显示发送中的消息
      final updatedMessages = [...state.messages, tempMessage];
      emit(state.copyWith(
        status: ChatStatus.success,
        messages: updatedMessages,
      ));

      // 实际发送消息
      final message = await _repository.sendMessage(
        _conversationId,
        event.content,
        event.type,
      );

      // 重新加载消息列表以获取最新状态
      add(MessageReceivedEvent(_conversationId));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: '发送消息失败: $e',
      ));
    }
  }

  Future<void> _onUpdateMessageStatus(
    UpdateMessageStatusEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _repository.updateMessageStatus(event.messageId, event.status);

      final updatedMessages = state.messages.map((message) {
        if (message.id == event.messageId) {
          return message.copyWith(status: event.status);
        }
        return message;
      }).toList();

      emit(state.copyWith(messages: updatedMessages));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '更新消息状态失败: $e',
      ));
    }
  }

  Future<void> _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final messages = await _repository.getMessages(_conversationId);
      emit(state.copyWith(
        status: ChatStatus.success,
        messages: messages,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '接收消息失败: $e',
      ));
    }
  }
}
