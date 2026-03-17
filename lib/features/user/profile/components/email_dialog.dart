import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class EmailDialog extends StatefulWidget {
  final ValueChanged<Map<String, String>> onSave;
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
  final _emailController = TextEditingController();
  final _emailCodeController = TextEditingController();
  bool _isCodeSending = false;
  int _countdown = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _emailCodeController.dispose();
    super.dispose();
  }

  void _sendEmailCode() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showToast('请先输入邮箱地址');
      return;
    }
    
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      _showToast('请输入有效的邮箱地址');
      return;
    }
    
    setState(() => _isCodeSending = true);
    
    // 开始倒计时
    setState(() => _countdown = 60);
    Future.delayed(const Duration(seconds: 1), () {
      _startCountdown();
    });
  }

  void _startCountdown() {
    if (_countdown > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _countdown--);
        _startCountdown();
      });
    } else {
      setState(() => _isCodeSending = false);
    }
  }

  void _save() {
    final email = _emailController.text.trim();
    final code = _emailCodeController.text.trim();
    
    if (email.isEmpty) {
      _showToast('请输入邮箱地址');
      return;
    }
    
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      _showToast('请输入有效的邮箱地址');
      return;
    }
    
    if (code.isEmpty) {
      _showToast('请输入验证码');
      return;
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      _showToast('请输入6位数字验证码');
      return;
    }
    
    widget.onSave({'email': email, 'code': code});
  }

  void _showToast(String message) {
    BeaverToast.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.w),
      ),
      child: Container(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '修改邮箱',
              style: TextStyle(
                fontSize: 32.w,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 32.w),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: '邮箱',
                labelStyle: TextStyle(
                  fontSize: 28.w,
                  color: const Color(0xFF636E72),
                ),
                hintText: '请输入邮箱地址',
                hintStyle: TextStyle(
                  fontSize: 28.w,
                  color: const Color(0xFFB2BEC3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.w),
                  borderSide: BorderSide(
                    color: const Color(0xFFE1E8ED),
                    width: 2.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.w),
                  borderSide: BorderSide(
                    color: const Color(0xFFFF7D45),
                    width: 2.w,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.w),
              ),
              style: TextStyle(
                fontSize: 28.w,
                color: const Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 24.w),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: '验证码',
                      labelStyle: TextStyle(
                        fontSize: 28.w,
                        color: const Color(0xFF636E72),
                      ),
                      hintText: '请输入验证码',
                      hintStyle: TextStyle(
                        fontSize: 28.w,
                        color: const Color(0xFFB2BEC3),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.w),
                        borderSide: BorderSide(
                          color: const Color(0xFFE1E8ED),
                          width: 2.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.w),
                        borderSide: BorderSide(
                          color: const Color(0xFFFF7D45),
                          width: 2.w,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.w),
                    ),
                    style: TextStyle(
                      fontSize: 28.w,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                GestureDetector(
                  onTap: _isCodeSending || _countdown > 0 ? null : _sendEmailCode,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.w),
                    decoration: BoxDecoration(
                      gradient: _isCodeSending || _countdown > 0
                          ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFB2BEC3),
                                Color(0xFF95A5A6),
                              ],
                            )
                          : const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFF7D45),
                                Color(0xFFE86835),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _countdown > 0 ? '${_countdown}s' : '发送验证码',
                      style: TextStyle(
                        fontSize: 24.w,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.w),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.w),
                      margin: EdgeInsets.only(right: 16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        border: Border.all(
                          color: const Color(0xFFE9ECEF),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 28.w,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF636E72),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _save,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.w),
                      margin: EdgeInsets.only(left: 16.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFF7D45),
                            Color(0xFFE86835),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '确定',
                        style: TextStyle(
                          fontSize: 28.w,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
