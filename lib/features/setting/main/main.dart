import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/main/bloc/bloc.dart';
import 'package:beaver/features/setting/main/bloc/event.dart';
import 'package:beaver/features/setting/main/bloc/state.dart';
import 'package:beaver/features/setting/main/data/repositories/repository.dart';
import 'package:beaver/shared/ui/button/button.dart';
import 'package:beaver/shared/ui/dialog/dialog.dart';
import 'package:beaver/shared/ui/header/header.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late SettingBloc _settingBloc;

  @override
  void initState() {
    super.initState();
    _settingBloc = SettingBloc(SettingRepository())..add(LoadSettingItemsEvent());
  }

  @override
  void dispose() {
    _settingBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _handleClickItem(int id) {
    switch (id) {
      case 1:
        // 账号与安�?
        break;
      case 2:
        // 隐私政策
        break;
      case 3:
        // 用户协议
        break;
      case 4:
        // 检查更�?
        break;
      case 5:
        // 主题设置
        break;
    }
  }

  void _handleLogout() {
    _settingBloc.add(LogoutEvent());
    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已退出登�?)),
    );
    // 延迟跳转
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: BlocProvider.value(
        value: _settingBloc,
        child: BlocConsumer<SettingBloc, SettingState>(
          listener: (context, state) {
            if (state.status == SettingStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? '发生错误')),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // 头部
                BeaverHeader(
                  title: '通用设置',
                  showBack: true,
                  onBack: _goBack,
                  showBackground: true,
                  backgroundType: 'gradient',
                  backgroundHeight: 120,
                ),
                // 内容
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 375.w),
                      margin: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width - 375.w) / 2),
                      child: Column(
                        children: [
                          // 账号与安全设�?
                          _buildSettingCard([
                            _buildSettingItem(1, '账号与安�?),
                          ]),
                          SizedBox(height: 24.w),
                          // 主题设置
                          _buildSettingCard([
                            _buildSettingItem(5, '主题设置'),
                          ]),
                          SizedBox(height: 24.w),
                          // 关于与支�?
                          _buildSettingCard([
                            _buildSettingItem(2, '隐私政策'),
                            _buildSettingItem(3, '用户协议'),
                            _buildSettingItem(4, '检查更�?),
                          ]),
                          SizedBox(height: 40.w),
                          // 退出登录按�?
                          GestureDetector(
                            onTap: () => _settingBloc.add(ShowLogoutDialogEvent()),
                            child: Container(
                              width: double.infinity,
                              height: 56.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF7D45),
                                borderRadius: BorderRadius.circular(28.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF7D45).withOpacity(0.2),
                                    offset: Offset(0, 4.w),
                                    blurRadius: 12.w,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '退出登�?,
                                style: TextStyle(
                                  fontSize: 16.w,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 退出登录对话框
                if (state.showLogoutDialog)
                  BeaverDialog(
                    title: '确认退出登�?,
                    content: '退出后需要重新登录才能使�?Beaver ，确定要退出吗�?,
                    type: 'warning',
                    size: 'medium',
                    confirmText: '确认退�?,
                    cancelText: '取消',
                    onConfirm: _handleLogout,
                    onCancel: () => _settingBloc.add(HideLogoutDialogEvent()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: Offset(0, 4.w),
            blurRadius: 12.w,
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem(int id, String title) {
    return GestureDetector(
      onTap: () => _handleClickItem(id),
      child: Container(
        height: 56.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFEBEEF5),
              width: 1.w,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.w,
                color: const Color(0xFF2D3436),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: const Color(0xFFB2BEC3),
            ),
          ],
        ),
      ),
    );
  }
}

