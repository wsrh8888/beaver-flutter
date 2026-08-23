/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

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
import 'package:beaver/store/circle/circle.dart';
import 'package:beaver/store/notification/notification.dart';
import 'package:beaver/store/message/message.dart';
import 'package:beaver/store/emoji/emoji.dart';
import 'package:beaver/store/update/update.dart';
import 'package:beaver/store/call/call.dart';
import 'package:beaver/store/message_media/message_media.dart';
import 'package:beaver/core/datasync/emoji/sync.dart';
import 'package:beaver/core/datasync/manager.dart' show syncManager;
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/shared/utils/storage_util.dart';

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

  /// 退出登录，清理所有状态和缓存 (对标 PC logout)
  Future<void> logout() async {
    // 1. 断开 WebSocket
    getIt<WsConnectionManager>().disconnect();

    // 2. 关闭本地数据库，避免下次登录仍持有已关闭连接
    await DatabaseManager.close();

    // 3. 清理本地存储 (token, userId 等)
    await StorageUtil.clear();

    // 3. 通知 UserStore 状态变更为未认证
    getIt<UserStore>().logout();

    // 4. 重置 AppStore 状态
    emit(const AppStoreState(
      status: AppLifecycleStatus.connecting,
      isInitComplete: false,
    ));

    // 建议：如果需要彻底清理数据库也可以在这里调用 clearLocalData()
    // 但通常退出登录只需清理 Session。如果用户要求清空缓存，则调用上面的 clearLocalData。
  }

  /**
   * @description: 启动应用一键初始化 (对标 desktop.initApp)
   * 先同步身份 ID，然后并行初始化其余业务
   */
  Future<void> initApp() async {
    if (DatabaseManager.currentUserId == null) return;

    emit(state.copyWith(status: AppLifecycleStatus.syncing));

    try {
      // 获取各模块 Store 实例
      final userStore = getIt<UserStore>();
      final contactStore = getIt<ContactStore>();
      final chatStore = getIt<ChatStore>();
      final friendStore = getIt<FriendStore>();
      final groupStore = getIt<GroupStore>();
      final circleStore = getIt<CircleStore>();
      final notificationStore = getIt<NotificationStore>();
      final messageStore = getIt<MessageStore>();
      final emojiStore = getIt<EmojiStore>();
      final updateStore = getIt<UpdateStore>();
      final callStore = getIt<CallStore>();
      final messageMediaStore = getIt<MessageMediaStore>();

      // 1. 先初始化基础数据底座 (ContactStore 存储全局用户 Metadata)
      await contactStore.init();

      // 2. 初始化身份 UserStore (确认身份并同步个人最新资料)
      await userStore.init();

      // 3. 并行执行其余业务初始化
      await Future.wait([
        chatStore.init(),
        friendStore.init(),
        groupStore.init(),
        circleStore.init(),
        notificationStore.init(),
        messageStore.init(),
        emojiStore.init(),
        updateStore.init(),
        callStore.init(),
        messageMediaStore.init(),
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
