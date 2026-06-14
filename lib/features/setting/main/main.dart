import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/main/bloc/bloc.dart';
import 'package:beaver/features/setting/main/bloc/event.dart';
import 'package:beaver/features/setting/main/bloc/state.dart';
import 'package:beaver/features/setting/main/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/store/app/app.dart';
import 'package:beaver/di/injection.dart';

class SettingMainPage extends StatefulWidget {
  const SettingMainPage({super.key});

  @override
  State<SettingMainPage> createState() => _SettingMainPageState();
}

class _SettingMainPageState extends State<SettingMainPage> {
  late SettingMainBloc _settingMainBloc;
  bool _showLogoutDialog = false;
  bool _showClearDataDialog = false;

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
            backgroundHeight: 60,
            overlay: _buildOverlay(context),
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

  Widget? _buildOverlay(BuildContext context) {
    if (!_showLogoutDialog && !_showClearDataDialog) return null;

    if (_showLogoutDialog) {
      return BeaverDialog(
        title: '退出登录',
        contentText: '退出后需要重新登录，确定要退出吗？',
        confirmText: '退出',
        confirmColor: const Color(0xFFF44336),
        cancelText: '取消',
        maskClosable: true,
        onCancel: () => setState(() => _showLogoutDialog = false),
        onConfirm: () async {
          setState(() => _showLogoutDialog = false);
          await getIt<AppStore>().logout();
          if (mounted) {
            context.go('/login');
          }
        },
      );
    }

    return BeaverDialog(
      title: '清理本地数据',
      contentText: '这将清除本地数据库中所有聊天、好友、群组及表情记录，是否继续？',
      confirmText: '确定清理',
      confirmColor: const Color(0xFFF44336),
      cancelText: '取消',
      maskClosable: true,
      onCancel: () => setState(() => _showClearDataDialog = false),
      onConfirm: () async {
        setState(() => _showClearDataDialog = false);
        await getIt<AppStore>().clearLocalData();
        if (mounted) {
          BeaverToast.show(context, '本地数据已清空');
        }
      },
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => setState(() => _showLogoutDialog = true),
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

  void _handleClearLocalData() {
    setState(() => _showClearDataDialog = true);
  }
}
