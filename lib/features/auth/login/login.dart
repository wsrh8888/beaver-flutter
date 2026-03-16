import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/auth/login/bloc/bloc.dart';
import 'package:beaver/features/auth/login/bloc/event.dart';
import 'package:beaver/features/auth/login/bloc/state.dart';
import 'package:beaver/features/auth/data/repositories/auth_repository.dart';
import 'package:beaver/core/theme/colors.dart';
import 'package:beaver/shared/ui/button/index.dart';
import 'package:beaver/router/router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authRepository: getIt<AuthRepository>(),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _emailTouched = false;
  bool _passwordTouched = false;

  bool get _isEmailValid {
    final email = _emailController.text;
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+\$').hasMatch(email);
  }

  bool get _isFormValid => _isEmailValid && _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.go(AppRoutes.home);
        } else if (state.status == LoginStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? '登录失败'),
              backgroundColor: const Color(0xFFFF7D45),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                    Text(
                      '欢迎回来',
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
                    SizedBox(height: 48.w),
                    // 欢迎文本
                    Text(
                      '登录您的海狸账号，开启社交新体验',
                      style: TextStyle(
                        fontSize: 28.w,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                    SizedBox(height: 64.w),
                    // 表单
                    _buildForm(),
                    SizedBox(height: 48.w),
                    // 注册链接
                    _buildRegisterLink(),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _buildForm() {
    return Column(
      children: [
        // 邮箱输入框
        _buildInput(
          controller: _emailController,
          hint: '邮箱地址',
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) => setState(() => _emailTouched = true),
          errorText: (_emailTouched && !_isEmailValid) ? '请输入有效邮箱地址' : null,
        ),
        SizedBox(height: 34.w),
        // 密码输入框
        _buildPasswordInput(),
        SizedBox(height: 48.w),
        // 忘记密码
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.forgetPassword),
            child: Text(
              '忘记密码?',
              style: TextStyle(
                color: const Color(0xFFFF7D45),
                fontWeight: FontWeight.w500,
                fontSize: 24.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 48.w),
        // 登录按钮
        _buildLoginButton(),
      ],
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    required Function(String) onChanged,
    String? errorText,
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
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
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

  Widget _buildPasswordInput() {
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
          padding: EdgeInsets.only(left: 32.w, right: 80.w),
          alignment: Alignment.center,
          child: TextField(
            controller: _passwordController,
            onChanged: (v) => setState(() => _passwordTouched = true),
            obscureText: _obscurePassword,
            style: TextStyle(
              fontSize: 30.w,
              color: const Color(0xFF2D3436),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '登录密码',
              hintStyle: TextStyle(
                color: const Color(0xFFB2BEC3),
                fontSize: 30.w,
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        // 密码可见性切换按钮
        Positioned(
          right: 16.w,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Container(
              width: 80.w,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                _obscurePassword
                    ? 'assets/images/login/eye.svg'
                    : 'assets/images/login/eye-slash.svg',
                width: 40.w,
                height: 40.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFB2BEC3),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    final isLoading = context.watch<LoginBloc>().state.status == LoginStatus.loading;
    final enabled = _isFormValid && !isLoading;

    // 使用 BeaverButton 组件
    return BeaverButton(
      text: '登录',
      onPressed: enabled
          ? () {
              context.read<LoginBloc>().add(
                LoginSubmitEvent(
                  email: _emailController.text,
                  password: _passwordController.text,
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

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '还没有账号? ',
          style: TextStyle(
            color: const Color(0xFF636E72),
            fontSize: 28.w,
          ),
        ),
        GestureDetector(
          onTap: () => context.push(AppRoutes.register),
          child: Text(
            '立即注册',
            style: TextStyle(
              color: const Color(0xFFFF7D45),
              fontWeight: FontWeight.w500,
              fontSize: 28.w,
            ),
          ),
        ),
      ],
    );
  }
}
