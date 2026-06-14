import 'dart:convert';

import 'package:beaver/api/auth.dart';
import 'package:beaver/shared/ui/button/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _oldTouched = false;
  bool _newTouched = false;
  bool _confirmTouched = false;
  bool _isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validatePassword(String value) => RegExp(r'^[^\s]{6,}$').hasMatch(value);

  String _hashPassword(String password) {
    return md5.convert(utf8.encode(password)).toString();
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _oldTouched = true;
      _newTouched = true;
      _confirmTouched = true;
    });

    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!_validatePassword(oldPassword)) {
      BeaverToast.show(context, '请输入当前密码');
      return;
    }
    if (!_validatePassword(newPassword)) {
      BeaverToast.show(context, '新密码长度不少于6位');
      return;
    }
    if (newPassword != confirmPassword) {
      BeaverToast.show(context, '两次输入的新密码不一致');
      return;
    }
    if (oldPassword == newPassword) {
      BeaverToast.show(context, '新密码不能与当前密码相同');
      return;
    }

    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final res = await updatePasswordApi(
        UpdatePasswordReq(
          oldPassword: _hashPassword(oldPassword),
          newPassword: _hashPassword(newPassword),
        ),
      );
      if (!mounted) {
        return;
      }
      if (res.isSuccess) {
        BeaverToast.show(context, '密码修改成功');
        context.pop();
        return;
      }
      BeaverToast.show(context, res.msg.isNotEmpty ? res.msg : '密码修改失败');
    } catch (_) {
      if (mounted) {
        BeaverToast.show(context, '密码修改失败');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '修改密码',
      showBack: true,
      showBackground: true,
      backgroundType: 'gradient',
      backgroundHeight: 60,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '为保障账号安全，修改密码前需验证当前密码。',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFFB2BEC3),
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.w),
            _buildCard([
              _buildPasswordField(
                label: '当前密码',
                controller: _oldPasswordController,
                obscure: _obscureOld,
                touched: _oldTouched,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
                onChanged: () => setState(() => _oldTouched = true),
                showBorder: true,
              ),
              _buildPasswordField(
                label: '新密码',
                controller: _newPasswordController,
                obscure: _obscureNew,
                touched: _newTouched,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                onChanged: () => setState(() => _newTouched = true),
                showBorder: true,
              ),
              _buildPasswordField(
                label: '确认新密码',
                controller: _confirmPasswordController,
                obscure: _obscureConfirm,
                touched: _confirmTouched,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                onChanged: () => setState(() => _confirmTouched = true),
                showBorder: false,
              ),
            ]),
            SizedBox(height: 32.w),
            BeaverButton(
              text: '确认修改',
              width: double.infinity,
              loading: _isLoading,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required bool touched,
    required VoidCallback onToggle,
    required VoidCallback onChanged,
    required bool showBorder,
  }) {
    final value = controller.text;
    String? errorText;
    if (touched && label != '确认新密码' && !_validatePassword(value)) {
      errorText = '密码长度不少于6位';
    }
    if (touched &&
        label == '确认新密码' &&
        value != _newPasswordController.text) {
      errorText = '两次输入不一致';
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 10.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFFB2BEC3),
            ),
          ),
          TextField(
            controller: controller,
            obscureText: obscure,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: '请输入$label',
              hintStyle: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFFDFE6E9),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20.sp,
                  color: const Color(0xFFB2BEC3),
                ),
                onPressed: onToggle,
              ),
              errorText: errorText,
            ),
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }
}
