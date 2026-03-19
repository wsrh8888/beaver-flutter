import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beaver/features/user/mine/bloc/bloc.dart';
import 'package:beaver/features/user/mine/bloc/event.dart';
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
            showHeader: false,
            isScrollable: true,
            child: Stack(
              children: [
                // 背景颜色
                Positioned.fill(
                  child: Container(color: const Color(0xFFF9FAFB)),
                ),
                // 1. 个人信息部
                _buildHeader(context, state),
                // 2. 内容区域
                _buildContent(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MineState state) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        // 渐变背景
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: statusBarHeight + 24.w, // 48rpx
            left: 16.w, // 32rpx
            right: 16.w, // 32rpx
            bottom: 80.w, // 160rpx
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(0.42, -0.91), // 150deg approx
              end: Alignment(-0.42, 0.91),
              colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32.w), // 64rpx
              bottomRight: Radius.circular(32.w),
            ),
          ),
          child: Column(
            children: [
              // 顶部操作栏
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _navigateToQRCode,
                  child: Container(
                    width: 36.w, // 72rpx
                    height: 36.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 2.w), // 4rpx
                          blurRadius: 8.w, // 16rpx
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/common/qrcode.svg',
                      width: 18.w, // 36rpx
                      height: 18.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.w), // 32rpx
              // 个人信息
              GestureDetector(
                onTap: _navigateToProfile,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    // 头像
                    Container(
                      width: 80.w, // 160rpx
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: Offset(0, 8.w), // 16rpx
                            blurRadius: 20.w, // 40rpx
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: BeaverAvatar(
                          size: 80.w,
                          name: state.userInfo.nickname,
                          url: state.userInfo.avatar,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.w), // 28rpx
                    Text(
                      state.userInfo.nickname.isEmpty
                          ? 'Beaver'
                          : state.userInfo.nickname,
                      style: TextStyle(
                        fontSize: 13.sp, // 严格对应 uniapp 生效的 26rpx (316行覆盖了308行)
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 2.w), // 4rpx
                    Text(
                      'ID: ${state.userInfo.userId.isEmpty ? '未设置' : state.userInfo.userId}',
                      style: TextStyle(
                        fontSize: 13.sp, // 26rpx
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 装饰圆圈 1
        Positioned(
          top: statusBarHeight + 20.w,
          right: 20.w,
          child: Container(
            width: 120.w, // 240rpx
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.4, -0.4),
                colors: [Colors.white.withOpacity(0.15), Colors.transparent],
                stops: const [0.3, 0.6],
              ),
            ),
          ),
        ),
        // 装饰圆圈 2
        Positioned(
          top: statusBarHeight + 80.w,
          left: 10.w,
          child: Container(
            width: 80.w, // 160rpx
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.4, -0.4),
                colors: [Colors.white.withOpacity(0.15), Colors.transparent],
                stops: const [0.3, 0.6],
              ),
            ),
          ),
        ),
        // 波浪底座 (Header::after replacement)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24.w, // 48rpx
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.w), // 64rpx
                topRight: Radius.circular(32.w),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, MineState state) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().statusBarHeight + 229.w,
      ), // 精确计算：285 (header高估算) - 56 (112rpx重叠)
      padding: EdgeInsets.only(
        left: 16.w, // 32rpx
        right: 16.w, // 32rpx
        bottom:
            66.w +
            MediaQuery.of(
              context,
            ).padding.bottom, // 32rpx (margin) + 100rpx (safe area gap)
      ),
      child: Column(
        children: [
          // 主体卡片
          Container(
            padding: EdgeInsets.all(18.w), // 36rpx
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.w), // 36rpx
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: Offset(0, 8.w), // 16rpx
                  blurRadius: 20.w, // 40rpx
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 2.w,
                    bottom: 14.w,
                  ), // 4rpx left, 28rpx bottom
                  child: Text(
                    '设置',
                    style: TextStyle(
                      fontSize: 15.sp, // 30rpx
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                ),
                // 设置列表
                _buildListItem(
                  icon: 'assets/images/common/settings.svg',
                  title: '通用',
                  onTap: _navigateToSettings,
                  iconBgColor: const Color(0xFFFF7D45).withOpacity(0.1),
                ),
                SizedBox(height: 8.w), // 16rpx
                _buildListItem(
                  icon: 'assets/images/common/feedback.svg',
                  title: '意见反馈',
                  onTap: _navigateToFeedback,
                  iconBgColor: const Color(0xFFFF9650).withOpacity(0.1),
                ),
                SizedBox(height: 8.w), // 16rpx
                _buildListItem(
                  icon: 'assets/images/common/about.svg',
                  title: '项目声明',
                  onTap: _navigateToDisclaimer,
                  iconBgColor: const Color(0xFFFFAF5F).withOpacity(0.1),
                ),
                SizedBox(height: 8.w), // 16rpx
                _buildListItem(
                  icon: 'assets/images/common/about.svg',
                  title: '关于 Beaver',
                  onTap: _navigateToAbout,
                  iconBgColor: const Color(0xFFFF7D45).withOpacity(0.1),
                ),
                SizedBox(height: 8.w), // 16rpx
                _buildListItem(
                  icon: 'assets/images/mine/setting.svg',
                  title: '检查更新',
                  onTap: _navigateToUpdate,
                  iconBgColor: const Color(0xFFFF9650).withOpacity(0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    required Color iconBgColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48.w, // 96rpx
        padding: EdgeInsets.symmetric(horizontal: 12.w), // 24rpx
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.w), // 20rpx
          border: Border.all(
            color: const Color(0xFFEBEEF5).withOpacity(0.7),
            width: 1.w, // 2rpx
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              offset: Offset(0, 1.w), // 2rpx
              blurRadius: 3.w, // 6rpx
            ),
          ],
        ),
        child: Row(
          children: [
            // 图标容器
            Container(
              width: 30.w, // 60rpx
              height: 30.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w), // 16rpx
                color: iconBgColor,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                icon,
                width: 16.w, // 32rpx
                height: 16.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFF7D45),
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 12.w), // 24rpx
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp, // 28rpx
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ),
            // 右侧箭头
            Container(
              width: 24.w, // 48rpx
              height: 24.w,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/common/jump_right.svg',
                width: 14.w, // 28rpx
                height: 14.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFB2BEC3),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
