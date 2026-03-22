import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/business/index.dart';

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
  final NotificationInboxBusiness _inboxBusiness;
  StreamSubscription? _subscription;

  NotificationStore({NotificationInboxBusiness? inboxBusiness})
    : _inboxBusiness = inboxBusiness ?? getIt<NotificationInboxBusiness>(),
      super(const NotificationStoreState()) {
    _subscription = _inboxBusiness.inboxUpdateStream.listen((_) => init());
    init();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> init() async {
    try {
      final userId = DatabaseManager.currentUserId;
      if (userId == null) return;

      final summary = await _inboxBusiness.getUnreadSummary(userId);
      emit(
        state.copyWith(
          unreadCount: summary['total'] as int? ?? 0,
          notifications: [], // 暂时不做详情列表，对标 PC Pinia store
        ),
      );
    } catch (e) {
      print('NotificationStore: 初始化失败: $e');
    }
  }

  // 暴露业务层以便未来直接调用
  NotificationInboxBusiness get business => _inboxBusiness;
}
