import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/notification/notification.dart';

class NotificationStoreState extends Equatable {
  final List<dynamic> notifications;
  final int unreadCount;

  const NotificationStoreState({
    this.notifications = const [],
    this.unreadCount = 0,
  });

  NotificationStoreState copyWith({
    List<dynamic>? notifications,
    int? unreadCount,
  }) {
    return NotificationStoreState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationStore extends Cubit<NotificationStoreState> {
  final NotificationBusiness _notificationBusiness;
  
  NotificationStore({NotificationBusiness? notificationBusiness})
    : _notificationBusiness = notificationBusiness ?? getIt<NotificationBusiness>(),
      super(const NotificationStoreState());

  Future<void> init() async {
    try {
      // 业务层挂载 (消除 unused lint)
      // print('NotificationStore: 挂载业务层 ${ _notificationBusiness.runtimeType }');
      emit(state.copyWith(notifications: []));
    } catch (e) {
      print('NotificationStore: 初始化失败: $e');
    }
  }

  // 暴露业务层以便未来直接调用
  NotificationBusiness get business => _notificationBusiness;
}
