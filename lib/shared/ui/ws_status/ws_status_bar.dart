import 'package:beaver/store/user/user.dart';
import 'package:beaver/store/ws/ws.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WsStatusBar extends StatelessWidget {
  const WsStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStore, UserStoreState>(
      buildWhen: (prev, curr) => prev.authStatus != curr.authStatus,
      builder: (context, userState) {
        if (userState.authStatus != AuthStatus.authenticated) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<WsStore, WsStoreState>(
          buildWhen: (prev, curr) =>
              prev.showBanner != curr.showBanner || prev.status != curr.status,
          builder: (context, state) {
            if (!state.showBanner) return const SizedBox.shrink();

            final isError = state.status == WsConnectionStatus.disconnected;
            return Container(
              width: double.infinity,
              height: 28.w,
              color: isError
                  ? const Color(0xFFFFF3E0)
                  : const Color(0xFFE8F4FD),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.status == WsConnectionStatus.connecting ||
                      state.status == WsConnectionStatus.syncing)
                    Padding(
                      padding: EdgeInsets.only(right: 6.w),
                      child: SizedBox(
                        width: 12.w,
                        height: 12.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5.w,
                          color: const Color(0xFF0984E3),
                        ),
                      ),
                    ),
                  Text(
                    state.bannerText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isError
                          ? const Color(0xFFE17055)
                          : const Color(0xFF0984E3),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
