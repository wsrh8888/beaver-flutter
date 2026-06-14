import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/router/router.dart';
import 'package:beaver/theme/colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/store/user/user.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/store/friend/friend_verify.dart';
import 'package:beaver/store/group/group.dart';
import 'package:beaver/store/group/group_member.dart';
import 'package:beaver/store/group/group_join_request.dart';
import 'package:beaver/store/notification/notification.dart';
import 'package:beaver/store/message/message.dart';
import 'package:beaver/store/emoji/emoji.dart';
import 'package:beaver/store/update/update.dart';
import 'package:beaver/store/ws/ws.dart';
import 'package:beaver/store/call/call.dart';
import 'package:beaver/store/call/call_list.dart';
import 'package:beaver/store/app/app.dart';
import 'package:beaver/features/setting/update/update_listener.dart';
import 'package:beaver/di/injection.dart';

import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/core/datasync/manager.dart';

class BeaverApp extends StatefulWidget {
  const BeaverApp({super.key});

  @override
  State<BeaverApp> createState() => _BeaverAppState();
}

class _BeaverAppState extends State<BeaverApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 1. 尝试唤醒 WS 连接
      getIt<WsConnectionManager>().onAppResume();
      // 2. 触发后台增量同步
      // 对标大厂策略：采用后台静默同步，避免阻塞用户 UI 体验
      syncManager.autoSync(isBackground: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            // 核心 App 状态，强制触发 initApp (对标 desktop.initApp)
            BlocProvider<AppStore>(
              lazy: false,
              create: (_) => getIt<AppStore>()..initApp(),
            ),
            // 分模块 Store (单例共享)
            BlocProvider<UserStore>(create: (_) => getIt<UserStore>()),
            BlocProvider<ContactStore>(create: (_) => getIt<ContactStore>()),
            BlocProvider<ChatStore>(create: (_) => getIt<ChatStore>()),
            BlocProvider<FriendStore>(create: (_) => getIt<FriendStore>()),
            BlocProvider<FriendVerifyStore>(
              create: (_) => getIt<FriendVerifyStore>(),
            ),
            BlocProvider<GroupStore>(create: (_) => getIt<GroupStore>()),
            BlocProvider<GroupMemberStore>(
              create: (_) => getIt<GroupMemberStore>(),
            ),
            BlocProvider<GroupJoinRequestStore>(
              create: (_) => getIt<GroupJoinRequestStore>(),
            ),
            BlocProvider<NotificationStore>(
              create: (_) => getIt<NotificationStore>(),
            ),
            BlocProvider<MessageStore>(create: (_) => getIt<MessageStore>()),
            BlocProvider<EmojiStore>(create: (_) => getIt<EmojiStore>()),
            BlocProvider<UpdateStore>(create: (_) => getIt<UpdateStore>()),
            BlocProvider<WsStore>(create: (_) => getIt<WsStore>()),
            BlocProvider<CallStore>(create: (_) => getIt<CallStore>()),
            BlocProvider<CallListStore>(create: (_) => getIt<CallListStore>()),
          ],
          child: MaterialApp.router(
            title: '海狸',
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
            builder: (context, child) => UpdateListener(
              child: child ?? const SizedBox.shrink(),
            ),
            theme: ThemeData(
              useMaterial3: true,
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                primary: AppColors.primary,
                onPrimary: Colors.white,
                surface: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
