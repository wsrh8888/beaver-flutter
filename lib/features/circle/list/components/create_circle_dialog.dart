import 'dart:io';

import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class CreateCircleDialog extends StatefulWidget {
  final bool submitting;
  final void Function(String name, String? avatarPath) onConfirm;
  final VoidCallback onCancel;

  const CreateCircleDialog({
    super.key,
    required this.submitting,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<CreateCircleDialog> createState() => _CreateCircleDialogState();
}

class _CreateCircleDialogState extends State<CreateCircleDialog> {
  late final TextEditingController _nameController;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    if (widget.submitting) return;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() => _avatarPath = pickedFile.path);
    }
  }

  void _submit() {
    if (widget.submitting) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    widget.onConfirm(name, _avatarPath);
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _nameController.text.trim().isNotEmpty && !widget.submitting;

    return BeaverDialog(
      title: '创建圈子',
      confirmText: '创建',
      cancelText: '取消',
      maskClosable: !widget.submitting,
      onCancel: widget.onCancel,
      onConfirm: canSubmit ? _submit : () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '圈子头像',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          GestureDetector(
            onTap: _pickAvatar,
            child: Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12.w),
                border: Border.all(
                  color: const Color(0xFFD8DEE6),
                  style: BorderStyle.solid,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: _avatarPath != null
                  ? Image.file(
                      File(_avatarPath!),
                      width: 72.w,
                      height: 72.w,
                      fit: BoxFit.cover,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/common/add.svg',
                          width: 16.w,
                          height: 16.w,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF636E72),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          '上传头像',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF636E72),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(height: 16.w),
          Text(
            '圈子名称',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.w),
              border: Border.all(color: const Color(0xFFEBEEF5)),
            ),
            child: TextField(
              controller: _nameController,
              maxLength: 32,
              enabled: !widget.submitting,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF2D3436),
              ),
              decoration: const InputDecoration(
                hintText: '例如：前端交流圈',
                hintStyle: TextStyle(color: Color(0xFFB2BEC3)),
                border: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          if (_avatarPath == null)
            Padding(
              padding: EdgeInsets.only(top: 8.w),
              child: Text(
                '头像可选，创建后可随时修改',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFFB2BEC3),
                ),
              ),
            ),
          if (widget.submitting)
            Padding(
              padding: EdgeInsets.only(top: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '创建中...',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
