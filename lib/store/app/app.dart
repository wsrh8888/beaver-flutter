import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/user/user.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/store/group/group.dart';
import 'package:beaver/store/notification/notification.dart';
import 'package:beaver/store/message/message.dart';
import 'package:beaver/store/emoji/emoji.dart';
import 'package:beaver/store/update/update.dart';
import 'package:beaver/store/call/call.dart';

enum AppLifecycleStatus { connecting, syncing, ready, error }

class AppStoreState extends Equatable {
  final AppLifecycleStatus status;
  final bool isInitComplete;
  final String? errorMessage;

  const AppStoreState({
    this.status = AppLifecycleStatus.connecting,
    this.isInitComplete = false,
    this.errorMessage,
  });

  AppStoreState copyWith({
    AppLifecycleStatus? status,
    bool? isInitComplete,
    String? errorMessage,
  }) {
    return AppStoreState(
      status: status ?? this.status,
      isInitComplete: isInitComplete ?? this.isInitComplete,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isInitComplete, errorMessage];
}

class AppStore extends Cubit<AppStoreState> {
  AppStore() : super(const AppStoreState());

  /**
   * @description: 启动应用一键初始化 (对标 desktop.initApp)
   * 先同步身份 ID，然后并行初始化其余业务
   */
  Future<void> initApp() async {
    print('AppStore: 开始应用一键初始化...');
    emit(state.copyWith(status: AppLifecycleStatus.syncing));

    try {
      // 获取各模块 Store 实例
      final userStore = getIt<UserStore>();
      final contactStore = getIt<ContactStore>();
      final chatStore = getIt<ChatStore>();
      final friendStore = getIt<FriendStore>();
      final groupStore = getIt<GroupStore>();
      final notificationStore = getIt<NotificationStore>();
      final messageStore = getIt<MessageStore>();
      final emojiStore = getIt<EmojiStore>();
      final updateStore = getIt<UpdateStore>();
      final callStore = getIt<CallStore>();

      // 1. 先初始化基础数据底座 (ContactStore 存储全局用户 Metadata)
      await contactStore.init();

      // 2. 初始化身份 UserStore (确认身份并同步个人最新资料)
      await userStore.init();

      // 3. 并行执行其余业务初始化
      await Future.wait([
        chatStore.init(),
        friendStore.init(),
        groupStore.init(),
        notificationStore.init(),
        messageStore.init(),
        emojiStore.init(),
        updateStore.init(),
        callStore.init(),
      ]);

      print('AppStore: 所有全局数据初始化完成');
      emit(
        state.copyWith(status: AppLifecycleStatus.ready, isInitComplete: true),
      );
    } catch (e) {
      print('AppStore: 应用初始化失败: $e');
      emit(
        state.copyWith(
          status: AppLifecycleStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// 更新应用生命周期状态
  void updateStatus(AppLifecycleStatus status) {
    emit(state.copyWith(status: status));
  }
}
