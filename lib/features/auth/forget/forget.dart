import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/button/button.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '找回密码',
      showBack: true,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: '请输入注册邮箱'),
            ),
            SizedBox(height: 16.w),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(hintText: '请输入验证码'),
            ),
            SizedBox(height: 16.w),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: '请输入新密码'),
            ),
            SizedBox(height: 32.w),
            BeaverButton(
              text: '重置密码',
              onPressed: () {
                BeaverToast.show(context, '重置成功');
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
