import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/user/mine/bloc/bloc.dart';
import 'package:beaver/features/user/mine/bloc/event.dart';
import 'package:beaver/features/user/mine/bloc/state.dart';
import 'package:beaver/features/user/mine/bloc/state.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  late MineBloc _mineBloc;

  @override
  void initState() {
    super.initState();
    _mineBloc = MineBloc()..add(LoadUserInfoEvent());
  }

  @override
  void dispose() {
    _mineBloc.close();
    super.dispose();
  }

  void _navigateToProfile() {
    context.go('/user/profile');
  }

  void _navigateToQRCode() {
    context.go('/user/qrcode');
  }

  void _navigateToSettings() {
    context.go('/setting');
  }

  void _navigateToFeedback() {
    context.go('/setting/feedback');
  }

  void _navigateToDisclaimer() {
    context.go('/setting/disclaimer');
  }

  void _navigateToAbout() {
    context.go('/setting/about');
  }

  void _navigateToUpdate() {
    context.go('/setting/update');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mineBloc,
      child: BlocConsumer<MineBloc, MineState>(
        listener: (context, state) {
          if (state.status == MineStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            showBackground: false,
            isScrollable: true,
            child: Stack(
              children: [
                // 个人信息头部
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 32.w,
                    right: 32.w,
                    bottom: 160.w,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFF7D45),
                        Color(0xFFE86835),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(64),
                      bottomRight: Radius.circular(64),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 顶部操作栏
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: _navigateToQRCode,
                            child: Container(
                              width: 72.w,
                              height: 72.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36.w),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.qr_code,
                                size: 36.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.w),
                      // 个人信息
                      GestureDetector(
                        onTap: _navigateToProfile,
                        child: Column(
                          children: [
                            Container(
                              width: 160.w,
                              height: 160.w,
                              margin: EdgeInsets.symmetric(horizontal: 32.w),
                              child: BeaverAvatar(
                                size: 160.w,
                                name: state.userInfo.nickname,
                              ),
                            ),
                            SizedBox(height: 28.w),
                            Text(
                              state.userInfo.nickname,
                              style: TextStyle(
                                fontSize: 40.w,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.w),
                            Text(
                              'ID: ${state.userInfo.userId}',
                              style: TextStyle(
                                fontSize: 26.w,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 主体卡片
                Container(
                  margin: EdgeInsets.only(top: 320.w),
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(36.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(36.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              offset: Offset(0, 16.w),
                              blurRadius: 40.w,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '设置',
                              style: TextStyle(
                                fontSize: 30.w,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                            SizedBox(height: 28.w),
                            // 设置项列表
                            _buildSettingItem(
                              icon: Icons.settings,
                              title: '通用',
                              onTap: _navigateToSettings,
                            ),
                            SizedBox(height: 16.w),
                            _buildSettingItem(
                              icon: Icons.feedback,
                              title: '意见反馈',
                              onTap: _navigateToFeedback,
                            ),
                            SizedBox(height: 16.w),
                            _buildSettingItem(
                              icon: Icons.info,
                              title: '项目声明',
                              onTap: _navigateToDisclaimer,
                            ),
                            SizedBox(height: 16.w),
                            _buildSettingItem(
                              icon: Icons.info_outline,
                              title: '关于 Beaver',
                              onTap: _navigateToAbout,
                            ),
                            SizedBox(height: 16.w),
                            _buildSettingItem(
                              icon: Icons.update,
                              title: '检查更新',
                              onTap: _navigateToUpdate,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96.w,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.w),
          border: Border.all(
            color: const Color(0xFFEBEEF5).withOpacity(0.7),
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              offset: Offset(0, 2.w),
              blurRadius: 6.w,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                color: const Color(0xFFFF7D45).withOpacity(0.1),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 32.w,
                color: const Color(0xFFFF7D45),
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 32.w,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 24.w,
              color: const Color(0xFFB2BEC3),
            ),
          ],
        ),
      ),
    );
  }
}

