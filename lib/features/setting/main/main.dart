import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/main/bloc/bloc.dart';
import 'package:beaver/features/setting/main/bloc/event.dart';
import 'package:beaver/features/setting/main/bloc/state.dart';
import 'package:beaver/features/setting/main/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/core/datasync/emoji/sync.dart';
import 'package:beaver/core/database/db.dart';

class SettingMainPage extends StatefulWidget {
  const SettingMainPage({super.key});

  @override
  State<SettingMainPage> createState() => _SettingMainPageState();
}

class _SettingMainPageState extends State<SettingMainPage> {
  late SettingMainBloc _settingMainBloc;

  @override
  void initState() {
    super.initState();
    _settingMainBloc = SettingMainBloc(SettingMainRepository())
      ..add(LoadSettingItemsEvent());
  }

  @override
  void dispose() {
    _settingMainBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _settingMainBloc,
      child: BlocConsumer<SettingMainBloc, SettingMainState>(
        listener: (context, state) {
          if (state.status == SettingMainStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? "错误");
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '通用设置',
            showBack: true,
            showBackground: true,
            backgroundType: 'gradient',
            backgroundHeight: 60, // 120rpx / 2 = 60px
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 40.w),
              child: Column(
                children: [
                  // 1. 账号与安全
                  _buildSettingsCard([
                    _buildSettingItem(
                      title: '账号与安全',
                      onTap: () => BeaverToast.show(
                        context,
                        '暂未开放',
                      ), // Placeholder since route is missing
                      showBorder: false,
                    ),
                  ]),
                  SizedBox(height: 24.w),

                  // 2. 主题与存储
                  _buildSettingsCard([
                    _buildSettingItem(
                      title: '主题设置',
                      onTap: () => context.push(AppRoutes.settingTheme),
                      showBorder: true,
                    ),
                    _buildSettingItem(
                      title: '清理本地数据',
                      onTap: _handleClearLocalData,
                      showBorder: false,
                    ),
                  ]),
                  SizedBox(height: 24.w),

                  // 3. 隐私与其支持
                  _buildSettingsCard([
                    _buildSettingItem(
                      title: '隐私政策',
                      onTap: () => context.push(AppRoutes.settingPrivacy),
                      showBorder: true,
                    ),
                    _buildSettingItem(
                      title: '用户协议',
                      onTap: () => context.push(AppRoutes.settingAgreement),
                      showBorder: true,
                    ),
                    _buildSettingItem(
                      title: '检查更新',
                      onTap: () => context.push(AppRoutes.settingUpdate),
                      showBorder: false,
                    ),
                  ]),
                  SizedBox(height: 40.w),

                  // 4. 退出登录按钮
                  _buildLogoutButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w), // Following uniapp 20px
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: Offset(0, 4.w),
            blurRadius: 12.w,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required VoidCallback onTap,
    bool showBorder = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: const Color(0xFFEBEEF5),
                    width: 1.w,
                  ),
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.w,
                color: const Color(0xFF2D3436),
                fontWeight: FontWeight.w400,
              ),
            ),
            SvgPicture.asset(
              'assets/images/setting/arrow-right.svg',
              width: 16.w,
              height: 16.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFFB2BEC3),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _showLogoutDialog,
      child: Container(
        width: double.infinity,
        height: 48.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: Offset(0, 4.w),
              blurRadius: 12.w,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '退出登录',
          style: TextStyle(
            fontSize: 16.w,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFF5252),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出登录'),
        content: const Text('退出后需要重新登录才能使用 Beaver ，确定要退出吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              BeaverToast.show(context, '已退出登录');
              context.go('/login');
            },
            child: const Text(
              '确认退出',
              style: TextStyle(color: Color(0xFFFF5252)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleClearLocalData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清理本地数据'),
        content: const Text('这将清除本地数据库中所有聊天、好友、群组及表情记录，是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // 1. 清除数据库所有表
              await DatabaseManager.instance.clearAllData();
              // 2. 清除表情同步记录 (文件等，如果有的话)
              await clearEmojiSyncState();
              if (mounted) {
                BeaverToast.show(context, '本地数据已清空');
              }
            },
            child: const Text(
              '确定清理',
              style: TextStyle(color: Color(0xFFFF5252)),
            ),
          ),
        ],
      ),
    );
  }
}
