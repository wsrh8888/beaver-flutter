import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/database/db.dart';
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
import 'package:beaver/core/datasync/emoji/sync.dart';
import 'package:beaver/core/datasync/manager.dart' show syncManager;

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
  StreamSubscription? _syncSubscription;

  AppStore() : super(const AppStoreState()) {
    // 监听同步管理器的状态
    _syncSubscription = syncManager.statusStream.listen((status) {
      if (status == 'ready') {
        // 全量同步完成，触发 AppStore 重新加载业务数据到内存
        initApp();
      } else if (status == 'syncing') {
        updateStatus(AppLifecycleStatus.syncing);
      } else if (status == 'error') {
        updateStatus(AppLifecycleStatus.error);
      }
    });
  }

  @override
  Future<void> close() {
    _syncSubscription?.cancel();
    return super.close();
  }

  /// Get the current local database instance (for debug tools like DriftDbViewer)
  AppDatabase get localDatabase => DatabaseManager.instance;

  /// Initialize the local database for the current user
  Future<void> initUserDatabase(String userId) async {
    await DatabaseManager.init(userId);
  }

  /// Clear all local user data
  Future<void> clearLocalData() async {
    await DatabaseManager.instance.clearAllData();
    await clearEmojiSyncState();
  }

  /**
   * @description: 启动应用一键初始化 (对标 desktop.initApp)
   * 先同步身份 ID，然后并行初始化其余业务
   */
  Future<void> initApp() async {
    // 增加守卫：如果没有初始化数据库，则跳过初始化 (可能是未登录状态)
    try {
      getIt<AppDatabase>();
    } catch (e) {
      return;
    }

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

      emit(
        state.copyWith(status: AppLifecycleStatus.ready, isInitComplete: true),
      );
    } catch (e) {
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
