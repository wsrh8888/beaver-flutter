import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/auth/forget/bloc/bloc.dart';
import 'package:beaver/features/auth/forget/bloc/event.dart';
import 'package:beaver/features/auth/forget/bloc/state.dart';
import 'package:beaver/features/auth/forget/data/models/reset_password.dart';
import 'package:beaver/features/auth/forget/data/repositories/repository.dart';
import 'package:beaver/shared/ui/button/button.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  late ForgetBloc _forgetBloc;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _codeFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _emailError = false;
  bool _codeError = false;
  bool _passwordError = false;
  bool _emailTouched = false;
  bool _codeTouched = false;
  bool _passwordTouched = false;

  @override
  void initState() {
    super.initState();
    _forgetBloc = ForgetBloc(ForgetRepository());
  }

  @override
  void dispose() {
    _forgetBloc.close();
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _codeFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return !_emailError && !_codeError && !_passwordError &&
           _emailController.text.isNotEmpty &&
           _codeController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty;
  }

  void _validateEmail() {
    _emailTouched = true;
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    setState(() {
      _emailError = !emailRegex.hasMatch(_emailController.text);
    });
  }

  void _validateCode() {
    _codeTouched = true;
    setState(() {
      _codeError = _codeController.text.isEmpty;
    });
  }

  void _validatePassword() {
    _passwordTouched = true;
    setState(() {
      _passwordError = !RegExp(r'^[^\s]{13,}$').hasMatch(_passwordController.text);
    });
  }

  void _sendVerificationCode() {
    _validateEmail();
    if (_emailError) return;

    _forgetBloc.add(SendVerificationCodeEvent(
      SendVerificationCodeRequest(
        email: _emailController.text,
        type: 'reset_password',
      ),
    ));
  }

  void _resetPassword() {
    _validateEmail();
    _validateCode();
    _validatePassword();
    if (!_isFormValid) return;

    _forgetBloc.add(ResetPasswordEvent(
      ResetPasswordRequest(
        email: _emailController.text,
        verificationCode: _codeController.text,
        password: _passwordController.text,
      ),
    ));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider.value(
        value: _forgetBloc,
        child: BlocConsumer<ForgetBloc, ForgetState>(
          listener: (context, state) {
            if (state.status == ForgetStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? '操作成功')),
              );
              if (state.errorMessage == '密码重置成功') {
                Future.delayed(const Duration(seconds: 2), _navigateToLogin);
              }
            } else if (state.status == ForgetStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? '发生错误')),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                children: [
                  // 顶部渐变区域
                  Container(
                    height: 240.w,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x14FF7D45),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Logo
                  Container(
                    width: 112.w,
                    height: 112.w,
                    margin: EdgeInsets.only(bottom: 48.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFF7D45),
                          Color(0xFFE86835),
                        ],
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
                    alignment: Alignment.center,
                    child: Text(
                      'B',
                      style: TextStyle(
                        fontSize: 48.w,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // 标题
                  Container(
                    margin: EdgeInsets.only(bottom: 16.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '找回密码',
                          style: TextStyle(
                            fontSize: 48.w,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 40.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7D45),
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 引导文本
                  Text(
                    '请输入您的邮箱地址和验证码，重置密码',
                    style: TextStyle(
                      fontSize: 28.w,
                      color: const Color(0xFF636E72),
                    ),
                    textAlign: TextAlign.center,
                    margin: EdgeInsets.only(bottom: 48.w),
                  ),
                  // 表单
                  Container(
                    margin: EdgeInsets.only(top: 20.w),
                    child: Column(
                      children: [
                        // 邮箱输入
                        Container(
                          margin: EdgeInsets.only(bottom: 34.w),
                          position: RelativeRect.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            children: [
                              Container(
                                height: 96.w,
                                padding: EdgeInsets.symmetric(horizontal: 32.w),
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
                                child: TextField(
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  onTap: () => _emailTouched = true,
                                  onChanged: (_) {
                                    setState(() => _emailError = false);
                                  },
                                  onEditingComplete: _validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: '邮箱地址',
                                    hintStyle: TextStyle(
                                      fontSize: 30.w,
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontSize: 30.w,
                                    color: const Color(0xFF2D3436),
                                  ),
                                ),
                              ),
                              if (_emailTouched && _emailError)
                                Container(
                                  margin: EdgeInsets.only(top: 8.w, left: 32.w),
                                  child: Text(
                                    '请输入有效邮箱地址',
                                    style: TextStyle(
                                      fontSize: 24.w,
                                      color: const Color(0xFFFF7D45),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // 验证码输入
                        Container(
                          margin: EdgeInsets.only(bottom: 34.w),
                          position: RelativeRect.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            children: [
                              Container(
                                height: 96.w,
                                padding: EdgeInsets.symmetric(horizontal: 32.w),
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _codeController,
                                        focusNode: _codeFocus,
                                        onTap: () => _codeTouched = true,
                                        onChanged: (_) {
                                          setState(() => _codeError = false);
                                        },
                                        onEditingComplete: _validateCode,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: '验证码',
                                          hintStyle: TextStyle(
                                            fontSize: 30.w,
                                            color: const Color(0xFFB2BEC3),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontSize: 30.w,
                                          color: const Color(0xFF2D3436),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: state.isCodeButtonDisabled ? null : _sendVerificationCode,
                                      child: Container(
                                        height: 72.w,
                                        padding: EdgeInsets.symmetric(horizontal: 28.w),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFFFF7D45),
                                              Color(0xFFE86835),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(20.w),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFFF7D45).withOpacity(0.15),
                                              offset: Offset(0, 4.w),
                                              blurRadius: 16.w,
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          state.isCodeButtonDisabled
                                              ? '${state.countdown}s'
                                              : '获取验证码',
                                          style: TextStyle(
                                            fontSize: 26.w,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_codeTouched && _codeError)
                                Container(
                                  margin: EdgeInsets.only(top: 8.w, left: 32.w),
                                  child: Text(
                                    '请输入验证码',
                                    style: TextStyle(
                                      fontSize: 24.w,
                                      color: const Color(0xFFFF7D45),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // 密码输入
                        Container(
                          margin: EdgeInsets.only(bottom: 34.w),
                          position: RelativeRect.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            children: [
                              Container(
                                height: 96.w,
                                padding: EdgeInsets.symmetric(horizontal: 32.w),
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
                                child: TextField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  onTap: () => _passwordTouched = true,
                                  onChanged: (_) {
                                    setState(() => _passwordError = false);
                                  },
                                  onEditingComplete: _validatePassword,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: '设置新密码',
                                    hintStyle: TextStyle(
                                      fontSize: 30.w,
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontSize: 30.w,
                                    color: const Color(0xFF2D3436),
                                  ),
                                ),
                              ),
                              if (_passwordTouched && _passwordError)
                                Container(
                                  margin: EdgeInsets.only(top: 8.w, left: 32.w),
                                  child: Text(
                                    '密码长度不少于13位，且不能包含空格',
                                    style: TextStyle(
                                      fontSize: 24.w,
                                      color: const Color(0xFFFF7D45),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // 重置密码按钮
                        BeaverButton(
                          text: '重置密码',
                          onPressed: _isFormValid ? _resetPassword : null,
                          width: double.infinity,
                          height: 96.w,
                          margin: EdgeInsets.only(top: 48.w),
                        ),
                        // 返回登录链接
                        Container(
                          margin: EdgeInsets.only(top: 24.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '记起密码了？',
                                style: TextStyle(
                                  fontSize: 28.w,
                                  color: const Color(0xFF636E72),
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToLogin,
                                child: Text(
                                  '返回登录',
                                  style: TextStyle(
                                    fontSize: 28.w,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFFF7D45),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
