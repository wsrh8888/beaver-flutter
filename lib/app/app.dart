import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/router/router.dart';
import 'package:beaver/theme/colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:beaver/store/app/app.dart';
import 'package:beaver/di/injection.dart';

class BeaverApp extends StatelessWidget {
  const BeaverApp({super.key});

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
            BlocProvider<GroupStore>(create: (_) => getIt<GroupStore>()),
            BlocProvider<NotificationStore>(
              create: (_) => getIt<NotificationStore>(),
            ),
            BlocProvider<MessageStore>(create: (_) => getIt<MessageStore>()),
            BlocProvider<EmojiStore>(create: (_) => getIt<EmojiStore>()),
            BlocProvider<UpdateStore>(create: (_) => getIt<UpdateStore>()),
            BlocProvider<CallStore>(create: (_) => getIt<CallStore>()),
          ],
          child: MaterialApp.router(
            title: '海狸',
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
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
