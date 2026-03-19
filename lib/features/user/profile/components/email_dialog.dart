import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/user/profile/bloc/bloc.dart';
import 'package:beaver/features/user/profile/bloc/event.dart';
import 'package:beaver/features/user/profile/bloc/state.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class EmailDialog extends StatefulWidget {
  final Function(Map<String, String>) onSave;
  final VoidCallback onCancel;

  const EmailDialog({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<EmailDialog> createState() => _EmailDialogState();
}

class _EmailDialogState extends State<EmailDialog> {
  late TextEditingController _emailController;
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _sendCode(BuildContext context) {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      BeaverToast.show(context, '请输入正确的邮箱');
      return;
    }
    context.read<ProfileBloc>().add(UpdateFormDataEvent('email', email));
    context.read<ProfileBloc>().add(SendEmailCodeEvent());
  }

  void _save() {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();
    if (email.isEmpty || code.isEmpty) return;
    widget.onSave({'email': email, 'code': code});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return BeaverDialog(
          title: '修改邮箱',
          onConfirm: _save,
          onCancel: widget.onCancel,
          child: Column(
            children: [
              // 邮箱输入
              _buildInputField(
                controller: _emailController,
                hint: '请输入新邮箱',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12.w),
              
              // 验证码输入
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2D3436)),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          hintText: '请输入验证码',
                          hintStyle: TextStyle(color: Color(0xFFB2BEC3)),
                          border: InputBorder.none,
                          counterText: '',
                          isDense: true,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: state.countdown > 0 || state.isCodeSending ? null : () => _sendCode(context),
                      child: Text(
                        state.isCodeSending ? '发送中...' : (state.countdown > 0 ? '${state.countdown}s' : '获取验证码'),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: state.countdown > 0 || state.isCodeSending 
                              ? const Color(0xFFB2BEC3) 
                              : const Color(0xFFFF7D45),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.w),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2D3436)),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB2BEC3)),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
