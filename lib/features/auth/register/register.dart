import 'dart:async';
import 'package:beaver/features/auth/register/data/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/auth/register/bloc/bloc.dart';
import 'package:beaver/features/auth/register/bloc/event.dart';
import 'package:beaver/features/auth/register/bloc/state.dart';
import 'package:beaver/core/theme/colors.dart';
import 'package:beaver/shared/ui/button/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/router/routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        authRepository: getIt<RegisterRepository>(),
      ),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  bool _validateEmail(String value) =>
      RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value);

  bool _validatePassword(String value) =>
      RegExp(r"^[^\s]{13,}$").hasMatch(value);

  bool get _isFormValid =>
      _validateEmail(_emailController.text) &&
      _validatePassword(_passwordController.text) &&
      _codeController.text.isNotEmpty &&
      _isAgreed;

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          context.go(AppRoutes.root);
        } else if (state.status == RegisterStatus.error) {
          BeaverToast.show(context, state.errorMessage ?? '注册失败');
        }
      },
      child: BeaverLayout(
        showBackground: true,
        showHeader: false,
        isScrollable: true,
        child: Column(
          children: [
            // 顶部渐变
            Container(
              height: 240.w,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x1AFF7D45),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // 内容区域
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                children: [
                  // Logo
                  _buildLogo(),
                  SizedBox(height: 48.w),
                  // 标题
                  _buildTitleSection(),
                  SizedBox(height: 64.w),
                  // 表单
                  _buildForm(),
                  SizedBox(height: 48.w),
                  // 底部链接
                  _buildBottomLinks(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 112.w,
      height: 112.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
        ),
        borderRadius: BorderRadius.circular(32.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7D45).withOpacity(0.2),
            offset: Offset(0, 8.w),
            blurRadius: 24.w,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 顶部光泽效果
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 56.w,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.w),
                  topRight: Radius.circular(32.w),
                ),
              ),
            ),
          ),
          // Logo图片
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 72.w,
              height: 72.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          '创建账号',
          style: TextStyle(
            fontSize: 48.w,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D3436),
            height: 1.3,
          ),
        ),
        SizedBox(height: 16.w),
        // 标题装饰线
        Container(
          width: 40.w,
          height: 4.w,
          color: const Color(0xFFFF7D45),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        // 邮箱输入框
        _buildInput(
          controller: _emailController,
          hint: '邮箱地址',
          onChanged: (v) => setState(() => _emailTouched = true),
          errorText: (_emailTouched && !_validateEmail(_emailController.text))
              ? '请输入有效邮箱地址'
              : null,
        ),
        SizedBox(height: 34.w),
        // 密码输入框
        _buildInput(
          controller: _passwordController,
          hint: '设置密码',
          obscureText: true,
          onChanged: (v) => setState(() => _passwordTouched = true),
          errorText:
              (_passwordTouched && !_validatePassword(_passwordController.text))
                  ? '密码长度不少于13位，且不能包含空格'
                  : null,
        ),
        SizedBox(height: 34.w),
        // 验证码输入框
        Stack(
          clipBehavior: Clip.none,
          children: [
            _buildInput(
              controller: _codeController,
              hint: '验证码',
              onChanged: (v) => setState(() => _codeTouched = true),
              errorText: (_codeTouched && _codeController.text.isEmpty)
                  ? '请输入验证码'
                  : null,
              paddingRight: 180.w,
            ),
            Positioned(
              right: 6.w,
              top: 0,
              bottom: 0,
              child: _buildCodeButton(),
            ),
          ],
        ),
        SizedBox(height: 24.w),
        // 用户协议
        GestureDetector(
          onTap: () => setState(() => _isAgreed = !_isAgreed),
          child: Row(
            children: [
              _buildCheckbox(),
              SizedBox(width: 20.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 24.w,
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
        ),
        SizedBox(height: 48.w),
        // 注册按钮 - 使用 BeaverButton 组件
        _buildRegisterBtn(),
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
          height: 96.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(28.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 2.w),
                blurRadius: 6.w,
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 32.w, right: paddingRight.w),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText,
            style: TextStyle(
              fontSize: 30.w,
              color: const Color(0xFF2D3436),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFFB2BEC3),
                fontSize: 30.w,
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (errorText != null)
          Positioned(
            bottom: -32.w,
            left: 32.w,
            child: Text(
              errorText,
              style: TextStyle(
                color: const Color(0xFFFF7D45),
                fontSize: 24.w,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCodeButton() {
    final enabled =
        !_isCodeButtonDisabled && _validateEmail(_emailController.text);
    return GestureDetector(
      onTap: enabled
          ? () {
              // 这里需要添加获取验证码的逻辑
              _startCountdown();
            }
          : null,
      child: Container(
        height: 72.w,
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
                )
              : LinearGradient(
                  colors: [Colors.grey[300]!, Colors.grey[400]!],
                ),
          borderRadius: BorderRadius.circular(20.w),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF7D45).withOpacity(0.15),
                    offset: Offset(0, 4.w),
                    blurRadius: 16.w,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          _isCodeButtonDisabled ? '${_countdown}s' : '获取验证码',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26.w,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: _isAgreed ? const Color(0xFFFF7D45) : Colors.white,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(
          color: _isAgreed ? const Color(0xFFFF7D45) : const Color(0xFFB2BEC3),
          width: 2.w,
        ),
      ),
      child: _isAgreed
          ? Center(
              child: Icon(
                Icons.check,
                size: 24.w,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildRegisterBtn() {
    final isLoading =
        context.watch<RegisterBloc>().state.status == RegisterStatus.loading;
    final enabled = _isFormValid && !isLoading;

    // 使用 BeaverButton 组件
    return BeaverButton(
      text: '注册',
      onPressed: enabled
          ? () {
              context.read<RegisterBloc>().add(
                    RegisterSubmitEvent(
                      email: _emailController.text,
                      password: _passwordController.text,
                      confirmPassword: _passwordController.text,
                    ),
                  );
            }
          : null,
      disabled: !enabled,
      loading: isLoading,
      width: double.infinity,
      height: 96.w,
      borderRadius: BorderRadius.circular(28.w),
    );
  }

  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '已有账号？',
          style: TextStyle(
            color: const Color(0xFF636E72),
            fontSize: 28.w,
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(),
          child: Text(
            '登录',
            style: TextStyle(
              color: const Color(0xFFFF7D45),
              fontSize: 28.w,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
