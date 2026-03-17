import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/features/chat/detail/data/repositories/repository.dart';
import 'package:beaver/features/chat/detail/data/models/types.dart';
import 'package:beaver/features/chat/detail/data/models/message.dart';
import 'package:uuid/uuid.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;
  StreamSubscription? _messageSubscription;
  final _uuid = const Uuid();

  ChatBloc(this._repository) : super(const ChatState()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MessageReceivedEvent>(_onMessageReceived);
  }

  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading, conversationId: event.conversationId));

    try {
      final conversation = await _repository.getConversation(event.conversationId);
      final messages = await _repository.getMessages(event.conversationId);

      _messageSubscription?.cancel();
      _messageSubscription = _repository.watchMessages(event.conversationId).listen((messages) {
        add(MessageReceivedEvent(event.conversationId));
      });

      emit(state.copyWith(
        status: ChatStatus.success,
        conversation: conversation,
        messages: messages,
      ));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    if (state.conversationId == null) return;

    final tempMessageId = _uuid.v4();
    final tempMessage = MessageModel(
      id: tempMessageId,
      conversationId: state.conversationId!,
      userId: 'me',
      content: event.content,
      type: event.type,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
      isSent: true,
    );

    final updatedMessages = List<MessageModel>.from(state.messages)..add(tempMessage);
    emit(state.copyWith(messages: updatedMessages));

    try {
      await _repository.sendMessage(state.conversationId!, event.content, event.type);
    } catch (e) {
      // 实际上 repository 已经处理了发送逻辑
    }
  }

  Future<void> _onMessageReceived(MessageReceivedEvent event, Emitter<ChatState> emit) async {
    if (event.conversationId == state.conversationId) {
      final messages = await _repository.getMessages(event.conversationId);
      emit(state.copyWith(messages: messages));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
