import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/core/theme/colors.dart';
import 'package:beaver/shared/widgets/beaver_layout.dart';
import 'package:beaver/shared/widgets/beaver_header.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  bool _validateEmail(String value) => RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(value);
  bool _validatePassword(String value) => RegExp(r"^[^\s]{13,}$").hasMatch(value);

  bool get _isFormValid => _validateEmail(_emailController.text) && _validatePassword(_passwordController.text) && _codeController.text.isNotEmpty && _isAgreed;

  void _startCountdown() {
    setState(() { _isCodeButtonDisabled = true; _countdown = 60; });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) { timer.cancel(); setState(() => _isCodeButtonDisabled = false); }
      else { setState(() => _countdown--); }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      showBackground: true,
      showHeader: false, // 注册页 header 也是手写的特别样式，先关掉系统 header
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 30.w),
            _buildLogo(),
            SizedBox(height: 24.w),
            _buildTitleSection(),
            SizedBox(height: 32.w),
            _buildForm(),
            SizedBox(height: 24.w),
            _buildBottomLinks(),
            SizedBox(height: 30.w),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 56.w, height: 56.w,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [BoxShadow(color: const Color(0xFFFF7D45).withOpacity(0.2), offset: Offset(0, 4.w), blurRadius: 12.w)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, height: 28.w, child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0)])))),
          Center(child: Image.asset('assets/images/logo.png', width: 36.w, height: 36.w, fit: BoxFit.contain)),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text('创建账号', style: TextStyle(fontSize: 24.w, fontWeight: FontWeight.w700, color: const Color(0xFF2D3436), height: 1.3)),
        SizedBox(height: 8.w),
        Container(width: 20.w, height: 2.w, color: const Color(0xFFFF7D45)),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildInput(controller: _emailController, hint: '邮箱地址', onChanged: (v) => setState(() => _emailTouched = true), errorText: (_emailTouched && !_validateEmail(_emailController.text)) ? '请输入有效邮箱地址' : null),
        SizedBox(height: 17.w),
        _buildInput(controller: _passwordController, hint: '设置密码', obscureText: true, onChanged: (v) => setState(() => _passwordTouched = true), errorText: (_passwordTouched && !_validatePassword(_passwordController.text)) ? '密码长度不少于13位，且不能包含空格' : null),
        SizedBox(height: 17.w),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            _buildInput(controller: _codeController, hint: '验证码', onChanged: (v) => setState(() => _codeTouched = true), errorText: (_codeTouched && _codeController.text.isEmpty) ? '请输入验证码' : null, paddingRight: 90.w),
            Positioned(right: 4.w, child: _buildCodeButton()),
          ],
        ),
        SizedBox(height: 12.w),
        GestureDetector(
          onTap: () => setState(() => _isAgreed = !_isAgreed),
          child: Row(
            children: [
              _buildCheckbox(),
              SizedBox(width: 10.w),
              Expanded(child: RichText(text: TextSpan(style: TextStyle(fontSize: 12.w, color: const Color(0xFF636E72)), children: [const TextSpan(text: '我已阅读并同意'), TextSpan(text: '用户协议', style: const TextStyle(color: Color(0xFFFF7D45), fontWeight: FontWeight.w500)), const TextSpan(text: '和'), TextSpan(text: '隐私政策', style: const TextStyle(color: Color(0xFFFF7D45), fontWeight: FontWeight.w500))]))),
            ],
          ),
        ),
        SizedBox(height: 24.w),
        _buildRegisterBtn(),
      ],
    );
  }

  Widget _buildInput({required TextEditingController controller, required String hint, bool obscureText = false, required Function(String) onChanged, String? errorText, double paddingRight = 16}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(height: 48.w, decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14.w), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 2), blurRadius: 6, spreadRadius: -1)]), padding: EdgeInsets.only(left: 16.w, right: paddingRight), alignment: Alignment.center, child: TextField(controller: controller, onChanged: onChanged, obscureText: obscureText, style: TextStyle(fontSize: 15.w, color: const Color(0xFF2D3436)), decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: TextStyle(color: const Color(0xFFB2BEC3), fontSize: 15.w), isDense: true))),
        if (errorText != null) Positioned(bottom: -16.w, left: 16.w, child: Text(errorText, style: TextStyle(color: const Color(0xFFFF7D45), fontSize: 12.w))),
      ],
    );
  }

  Widget _buildCodeButton() {
    final enabled = !_isCodeButtonDisabled && _validateEmail(_emailController.text);
    return GestureDetector(
      onTap: enabled ? _startCountdown : null,
      child: Container(height: 36.w, padding: EdgeInsets.symmetric(horizontal: 14.w), decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(10.w), boxShadow: [BoxShadow(color: const Color(0xFFFF7D45).withOpacity(0.15), offset: const Offset(0, 2), blurRadius: 8)]), alignment: Alignment.center, child: Text(_isCodeButtonDisabled ? '${_countdown}s' : '获取验证码', style: TextStyle(color: Colors.white, fontSize: 13.w, fontWeight: FontWeight.w500))),
    );
  }

  Widget _buildCheckbox() {
    return Container(width: 18.w, height: 18.w, decoration: BoxDecoration(color: _isAgreed ? const Color(0xFFFF7D45) : Colors.white, borderRadius: BorderRadius.circular(5.w), border: Border.all(color: _isAgreed ? const Color(0xFFFF7D45) : const Color(0xFFB2BEC3), width: 1.w)), child: _isAgreed ? Center(child: Icon(Icons.check, size: 12.w, color: Colors.white)) : null);
  }

  Widget _buildRegisterBtn() {
    final enabled = _isFormValid;
    return GestureDetector(
      onTap: enabled ? () {} : null,
      child: Container(width: double.infinity, height: 48.w, decoration: BoxDecoration(gradient: enabled ? AppColors.primaryGradient : LinearGradient(colors: [const Color(0xFFFF7D45).withOpacity(0.3), const Color(0xFFE86835).withOpacity(0.3)]), borderRadius: BorderRadius.circular(14.w), boxShadow: enabled ? [BoxShadow(color: const Color(0xFFFF7D45).withOpacity(0.15), offset: Offset(0, 4.w), blurRadius: 12.w)] : null), alignment: Alignment.center, child: Text('注册', style: TextStyle(color: Colors.white, fontSize: 16.w, fontWeight: FontWeight.w600))),
    );
  }

  Widget _buildBottomLinks() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('已有账号？', style: TextStyle(color: const Color(0xFF636E72), fontSize: 14.w)), GestureDetector(onTap: () => context.pop(), child: Text('登录', style: TextStyle(color: const Color(0xFFFF7D45), fontSize: 14.w, fontWeight: FontWeight.w500)))]);
  }
}
