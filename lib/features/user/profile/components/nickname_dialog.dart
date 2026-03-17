import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class NicknameDialog extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onSave;
  final VoidCallback onCancel;

  const NicknameDialog({
    super.key,
    required this.initialValue,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<NicknameDialog> createState() => _NicknameDialogState();
}

class _NicknameDialogState extends State<NicknameDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final nickname = _controller.text.trim();
    if (nickname.isEmpty) {
      _showToast('昵称不能为空');
      return;
    }
    widget.onSave(nickname);
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
              '修改昵称',
              style: TextStyle(
                fontSize: 32.w,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 32.w),
            TextField(
              controller: _controller,
              maxLength: 20,
              decoration: InputDecoration(
                hintText: '请输入昵称',
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
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_controller.text.length}/20',
                style: TextStyle(
                  fontSize: 22.w,
                  color: const Color(0xFFB2BEC3),
                ),
              ),
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
