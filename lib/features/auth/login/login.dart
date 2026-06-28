import 'package:flutter/material.dart';
import 'package:beaver/features/auth/login/data/repositories/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/auth/login/bloc/bloc.dart';
import 'package:beaver/features/auth/login/bloc/event.dart';
import 'package:beaver/features/auth/login/bloc/state.dart';
import 'package:beaver/theme/colors.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/utils/qrcode/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authRepository: getIt<LoginRepository>()),
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
  static const _pageBackground = BoxDecoration(
    color: Color(0xFFF9FAFB),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x1AFF7D45), Color(0x00FFFFFF)],
    ),
  );

  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _obscurePassword = true;
  bool _emailTouched = false;
  bool _passwordTouched = false;

  bool get _isEmailValid {
    final email = _emailController.text.trim();
    return RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(email);
  }

  void _handleLogin() {
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
    });

    if (!_isEmailValid) {
      BeaverToast.show(context, '请输入有效的邮箱地址');
      return;
    }
    if (_passwordController.text.isEmpty) {
      BeaverToast.show(context, '请输入登录密码');
      return;
    }

    final isLoading =
        context.read<LoginBloc>().state.status == LoginStatus.loading;
    if (isLoading) return;

    context.read<LoginBloc>().add(
      LoginSubmitEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state.status == LoginStatus.success) {
          final pendingScene = await consumePendingOAuthScene();
          if (pendingScene != null && pendingScene.isNotEmpty && context.mounted) {
            context.go('${AppRoutes.oauthScanConfirm}?sceneId=${Uri.encodeComponent(pendingScene)}');
            return;
          }
          context.go(AppRoutes.root);
        } else if (state.status == LoginStatus.error) {
          BeaverToast.show(context, state.errorMessage ?? '登录失败');
        }
      },
      child: BeaverLayout(
        showBack: false,
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
              _buildRegisterLink(),
              SizedBox(height: 30.w),
            ],
          ),
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
          '欢迎回来',
          style: TextStyle(
            fontSize: 24.w,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D3436),
            height: 1.3,
          ),
        ),
        SizedBox(height: 8.w),
        Container(width: 20.w, height: 2.w, color: const Color(0xFFFF7D45)),
        SizedBox(height: 24.w),
        Text(
          '登录您的海狸账号，开启社交新体验',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.w, color: const Color(0xFF636E72)),
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
          onChanged: (v) => setState(() => _emailTouched = true),
          errorText: (_emailTouched && !_isEmailValid) ? '请输入有效邮箱地址' : null,
        ),
        SizedBox(height: 17.w),
        _buildInput(
          controller: _passwordController,
          hint: '登录密码',
          obscureText: _obscurePassword,
          onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
          isPassword: true,
          onChanged: (v) => setState(() => _passwordTouched = true),
          errorText: (_passwordTouched && _passwordController.text.isEmpty)
              ? '请输入登录密码'
              : null,
        ),
        SizedBox(height: 10.w),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => context.go(AppRoutes.forgotPassword),
            child: Text(
              '忘记密码?',
              style: TextStyle(
                color: const Color(0xFFFF7D45),
                fontSize: 12.w,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 24.w),
        _buildLoginBtn(),
      ],
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
    required Function(String) onChanged,
    String? errorText,
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
                offset: Offset(0, 2.w),
                blurRadius: 6.w,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  obscureText: obscureText,
                  style: TextStyle(
                    fontSize: 15.w,
                    color: const Color(0xFF2D3436),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: const Color(0xFFB2BEC3),
                      fontSize: 15.w,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              if (isPassword)
                GestureDetector(
                  onTap: onToggle,
                  child: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20.w,
                    color: const Color(0xFFB2BEC3),
                  ),
                ),
            ],
          ),
        ),
        if (errorText != null)
          Positioned(
            bottom: -16.w,
            left: 16.w,
            child: Text(
              errorText,
              style: TextStyle(color: const Color(0xFFFF7D45), fontSize: 12.w),
            ),
          ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    final isLoading =
        context.watch<LoginBloc>().state.status == LoginStatus.loading;
    return GestureDetector(
      onTap: _handleLogin,
      child: Container(
        width: double.infinity,
        height: 48.w,
        decoration: BoxDecoration(
          gradient: !isLoading ? AppColors.primaryGradient : null,
          color: !isLoading ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(14.w),
          boxShadow: !isLoading
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF7D45).withOpacity(0.2),
                    offset: Offset(0, 4.w),
                    blurRadius: 10.w,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                '登录',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.w,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '还没有账号? ',
          style: TextStyle(color: const Color(0xFF636E72), fontSize: 14.w),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.register),
          child: Text(
            '立即注册',
            style: TextStyle(
              color: const Color(0xFFFF7D45),
              fontWeight: FontWeight.bold,
              fontSize: 14.w,
            ),
          ),
        ),
      ],
    );
  }
}
