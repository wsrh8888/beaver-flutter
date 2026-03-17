import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class GenderDialog extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onSave;
  final VoidCallback onCancel;

  const GenderDialog({
    super.key,
    required this.initialValue,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<GenderDialog> createState() => _GenderDialogState();
}

class _GenderDialogState extends State<GenderDialog> {
  late int _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialValue;
  }

  void _selectGender(int gender) {
    setState(() => _selectedGender = gender);
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
              '选择性别',
              style: TextStyle(
                fontSize: 32.w,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 32.w),
            Column(
              children: [
                GestureDetector(
                  onTap: () => _selectGender(1),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
                    margin: EdgeInsets.only(bottom: 16.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedGender == 1 
                            ? const Color(0xFFFF7D45)
                            : const Color(0xFFE1E8ED),
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(16.w),
                      color: _selectedGender == 1
                          ? const Color(0xFFFF7D45).withOpacity(0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '男',
                          style: TextStyle(
                            fontSize: 28.w,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedGender == 1
                                  ? const Color(0xFFFF7D45)
                                  : const Color(0xFFE1E8ED),
                              width: 2.w,
                            ),
                            color: _selectedGender == 1
                                ? const Color(0xFFFF7D45)
                                : Colors.white,
                          ),
                          child: _selectedGender == 1
                              ? Icon(
                                  Icons.check,
                                  size: 24.w,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectGender(2),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
                    margin: EdgeInsets.only(bottom: 16.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedGender == 2 
                            ? const Color(0xFFFF7D45)
                            : const Color(0xFFE1E8ED),
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(16.w),
                      color: _selectedGender == 2
                          ? const Color(0xFFFF7D45).withOpacity(0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '女',
                          style: TextStyle(
                            fontSize: 28.w,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedGender == 2
                                  ? const Color(0xFFFF7D45)
                                  : const Color(0xFFE1E8ED),
                              width: 2.w,
                            ),
                            color: _selectedGender == 2
                                ? const Color(0xFFFF7D45)
                                : Colors.white,
                          ),
                          child: _selectedGender == 2
                              ? Icon(
                                  Icons.check,
                                  size: 24.w,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectGender(0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedGender == 0 
                            ? const Color(0xFFFF7D45)
                            : const Color(0xFFE1E8ED),
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(16.w),
                      color: _selectedGender == 0
                          ? const Color(0xFFFF7D45).withOpacity(0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '保密',
                          style: TextStyle(
                            fontSize: 28.w,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedGender == 0
                                  ? const Color(0xFFFF7D45)
                                  : const Color(0xFFE1E8ED),
                              width: 2.w,
                            ),
                            color: _selectedGender == 0
                                ? const Color(0xFFFF7D45)
                                : Colors.white,
                          ),
                          child: _selectedGender == 0
                              ? Icon(
                                  Icons.check,
                                  size: 24.w,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
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
                    onTap: () => widget.onSave(_selectedGender),
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
