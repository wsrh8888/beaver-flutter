import 'package:beaver/di/injection.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  String _maskPhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return '未绑定';
    }
    if (phone.length < 7) {
      return phone;
    }
    return '${phone.substring(0, 3)}****${phone.substring(phone.length - 4)}';
  }

  String _maskEmail(String? email) {
    if (email == null || email.isEmpty) {
      return '未绑定';
    }
    final parts = email.split('@');
    if (parts.length != 2) {
      return email;
    }
    final name = parts[0];
    final maskedName = name.length <= 2
        ? '${name[0]}*'
        : '${name.substring(0, 2)}***';
    return '$maskedName@${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStore, UserStoreState>(
      builder: (context, userState) {
        final userInfo = getIt<UserStore>().getUserInfo(getIt<ContactStore>());
        final phone = userInfo?.phone;
        final email = userInfo?.email;

        return BeaverLayout(
          title: '账号与安全',
          showBack: true,
          showBackground: true,
          backgroundType: 'gradient',
          backgroundHeight: 60,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 40.w),
            child: Column(
              children: [
                _buildCard([
                  _buildItem(
                    title: '手机号',
                    subtitle: _maskPhone(phone),
                    onTap: () => context.push(AppRoutes.profile),
                    showBorder: true,
                  ),
                  _buildItem(
                    title: '邮箱',
                    subtitle: _maskEmail(email),
                    onTap: () => context.push(AppRoutes.profile),
                    showBorder: false,
                  ),
                ]),
                SizedBox(height: 24.w),
                _buildCard([
                  _buildItem(
                    title: '修改密码',
                    subtitle: '定期更换密码可提升账号安全性',
                    onTap: () => context.push(AppRoutes.settingChangePassword),
                    showBorder: true,
                  ),
                  _buildItem(
                    title: '登录设备管理',
                    subtitle: '查看并管理已登录的设备',
                    onTap: () => context.push(AppRoutes.settingDevices),
                    showBorder: false,
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(List<Widget> children) {
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
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showBorder = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF2D3436),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFFB2BEC3),
                    ),
                  ),
                ],
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
}
