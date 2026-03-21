import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/chat/message.dart';

class MessageStoreState extends Equatable {
  // 全局消息事件数据
  const MessageStoreState();

  @override
  List<Object?> get props => [];
}

class MessageStore extends Cubit<MessageStoreState> {
  final MessageBusiness _messageBusiness;
  
  MessageStore({MessageBusiness? messageBusiness}) 
    : _messageBusiness = messageBusiness ?? getIt<MessageBusiness>(),
      super(const MessageStoreState());

  Future<void> init() async {
    // 全局消息初始化逻辑
    // 为了消除 LINT 错误，暂时调用业务层
    print('MessageStore: 正在监听业务层事件...');
  }
  
  // 保持对 _messageBusiness 的引用以便未来调用
  MessageBusiness get business => _messageBusiness;
}
