import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/api/auth.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/ui/button/index.dart';
import 'package:beaver/router/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const _pageBackground = BoxDecoration(
    color: Color(0xFFF9FAFB),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x1AFF7D45), Color(0x00FFFFFF)],
    ),
  );

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  bool _isAgreed = false;
  bool _isCodeButtonDisabled = false;
  int _countdown = 60;
  Timer? _timer;

  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _codeTouched = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  bool _validateEmail(String value) =>
      RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(value);

  bool _validatePassword(String value) =>
      RegExp(r"^[^\s]{6,}$").hasMatch(value);

  bool get _isFormValid =>
      _validateEmail(_emailController.text.trim()) &&
      _validatePassword(_passwordController.text) &&
      _codeController.text.trim().isNotEmpty &&
      _isAgreed &&
      !_isLoading;

  void _startCountdown() {
    setState(() {
      _isCodeButtonDisabled = true;
      _countdown = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        setState(() => _isCodeButtonDisabled = false);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  Future<void> _sendCode() async {
    setState(() => _emailTouched = true);
    if (!_validateEmail(_emailController.text)) return;

    try {
      final res = await getEmailCodeApi(
        GetEmailCodeReq(email: _emailController.text, type: 'register'),
      );
      if (res.code == 0) {
        BeaverToast.show(context, '验证码已发送');
        _startCountdown();
      } else {
        BeaverToast.show(context, res.msg);
      }
    } catch (e) {
      BeaverToast.show(context, '发送失败');
    }
  }

  Future<void> _handleRegister() async {
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
      _codeTouched = true;
    });

    if (!_validateEmail(_emailController.text.trim())) {
      BeaverToast.show(context, '请输入有效的邮箱地址');
      return;
    }
    if (!_validatePassword(_passwordController.text)) {
      BeaverToast.show(context, '密码长度不少于6位');
      return;
    }
    if (_codeController.text.trim().isEmpty) {
      BeaverToast.show(context, '请输入验证码');
      return;
    }
    if (!_isAgreed) {
      BeaverToast.show(context, '请先阅读并同意用户协议');
      return;
    }

    if (_isLoading) return;
    try {
      final passwordMd5 = md5
          .convert(utf8.encode(_passwordController.text))
          .toString();
      final res = await emailRegisterApi(
        EmailRegisterReq(
          email: _emailController.text,
          password: passwordMd5,
          code: _codeController.text,
        ),
      );

      if (res.code == 0) {
        BeaverToast.show(context, '注册成功');
        if (mounted) {
          context.go('/login');
        }
      } else {
        BeaverToast.show(context, res.msg);
      }
    } catch (e) {
      BeaverToast.show(context, '注册失败，请稍后重试');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      headerBackground: Colors.transparent,
      showWsStatus: false,
      fullScreenBackground:
          const DecoratedBox(decoration: _pageBackground),
      isScrollable: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 16.w),
            _buildLogo(),
            SizedBox(height: 24.w),
            _buildTitleSection(),
            SizedBox(height: 32.w),
            _buildForm(),
            SizedBox(height: 24.w),
            _buildBottomLinks(),
            SizedBox(height: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      width: 80.w,
      height: 80.w,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          '创建账号',
          style: TextStyle(
            fontSize: 24.w,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D3436),
            height: 1.3,
          ),
        ),
        SizedBox(height: 8.w),
        Container(
          width: 20.w,
          height: 2.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFF7D45),
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildInput(
          controller: _emailController,
          hint: '邮箱地址',
          onChanged: (v) => setState(() => {}),
          errorText:
              (_emailTouched && !_validateEmail(_emailController.text.trim()))
              ? '请输入有效邮箱地址'
              : null,
        ),
        SizedBox(height: 17.w),
        _buildInput(
          controller: _passwordController,
          hint: '设置密码',
          obscureText: true,
          onChanged: (v) => setState(() => {}),
          errorText:
              (_passwordTouched && !_validatePassword(_passwordController.text))
              ? '密码长度不少于6位，且不能包含空格'
              : null,
        ),
        SizedBox(height: 17.w),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _buildInput(
              controller: _codeController,
              hint: '验证码',
              onChanged: (v) => setState(() => {}),
              errorText: (_codeTouched && _codeController.text.trim().isEmpty)
                  ? '请输入验证码'
                  : null,
              paddingRight: 110.w,
            ),
            Positioned(
              right: 3.w,
              top: 3.w,
              bottom: 3.w,
              child: _buildCodeButton(),
            ),
          ],
        ),
        SizedBox(height: 17.w),
        // 用户协议
        _buildAgreementSection(),
        SizedBox(height: 24.w),
        // 注册按钮
        BeaverButton(
          text: '注册',
          onPressed: _handleRegister,
          loading: _isLoading,
          width: double.infinity,
          height: 48.w,
          borderRadius: BorderRadius.circular(14.w),
        ),
      ],
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    required Function(String) onChanged,
    String? errorText,
    double paddingRight = 32,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 48.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(14.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 1.w),
                blurRadius: 3.w,
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 16.w, right: paddingRight.w),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            onChanged: (v) {
              setState(() {});
              onChanged(v);
            },
            obscureText: obscureText,
            style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFFB2BEC3),
                fontSize: 15.sp,
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (errorText != null)
          Positioned(
            bottom: -16.w,
            left: 16.w,
            child: Text(
              errorText,
              style: TextStyle(color: const Color(0xFFFF7D45), fontSize: 12.sp),
            ),
          ),
      ],
    );
  }

  Widget _buildCodeButton() {
    final enabled =
        !_isCodeButtonDisabled && _validateEmail(_emailController.text);
    return GestureDetector(
      onTap: enabled ? _sendCode : null,
      child: Container(
        constraints: BoxConstraints(minWidth: 70.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
          ),
          borderRadius: BorderRadius.circular(10.w),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF7D45).withOpacity(0.15),
                    offset: Offset(0, 2.w),
                    blurRadius: 8.w,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.6,
          child: Text(
            _isCodeButtonDisabled ? '${_countdown}s' : '获取验证码',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementSection() {
    return GestureDetector(
      onTap: () => setState(() => _isAgreed = !_isAgreed),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          _buildCheckbox(),
          SizedBox(width: 10.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF636E72),
                ),
                children: [
                  const TextSpan(text: '我已阅读并同意'),
                  TextSpan(
                    text: '用户协议',
                    style: const TextStyle(
                      color: Color(0xFFFF7D45),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(text: '和'),
                  TextSpan(
                    text: '隐私政策',
                    style: const TextStyle(
                      color: Color(0xFFFF7D45),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        color: _isAgreed ? const Color(0xFFFF7D45) : Colors.white,
        borderRadius: BorderRadius.circular(5.w),
        border: Border.all(
          color: _isAgreed ? const Color(0xFFFF7D45) : const Color(0xFFB2BEC3),
          width: 1.w,
        ),
      ),
      child: _isAgreed
          ? Center(
              child: Icon(Icons.check, size: 12.w, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '已有账号？',
          style: TextStyle(color: const Color(0xFF636E72), fontSize: 14.sp),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.login),
          child: Text(
            '返回登录',
            style: TextStyle(
              color: const Color(0xFFFF7D45),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
