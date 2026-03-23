import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/dialog/index.dart';

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
  late int _gender;

  @override
  void initState() {
    super.initState();
    _gender = widget.initialValue == 0 ? 1 : widget.initialValue;
  }

  void _save() {
    widget.onSave(_gender);
  }

  @override
  Widget build(BuildContext context) {
    return BeaverDialog(
      title: '选择性别',
      onConfirm: _save,
      onCancel: widget.onCancel,
      child: Column(
        children: [
          _buildItem('男', 1),
          SizedBox(height: 12.w),
          _buildItem('女', 2),
          SizedBox(height: 12.w),
        ],
      ),
    );
  }

  Widget _buildItem(String label, int value) {
    bool active = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFF7F2) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(
            color: active ? const Color(0xFFFF7D45) : Colors.transparent,
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                color: active ? const Color(0xFFFF7D45) : const Color(0xFF2D3436),
              ),
            ),
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? const Color(0xFFFF7D45) : const Color(0xFFDCDFE6),
                  width: 1.5.w,
                ),
              ),
              alignment: Alignment.center,
              child: active 
                ? Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF7D45),
                    ),
                  )
                : null,
            ),
          ],
        ),
      ),
    );
  }
}
