import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ToolItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const ToolItem({super.key, required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(width: 58.w, height: 58.w, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.w), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))]), child: Center(child: SvgPicture.asset('assets/images/chat/$icon.svg', width: 28.w, height: 28.w))),
        SizedBox(height: 10.w),
        Text(label, style: TextStyle(fontSize: 11.sp, color: const Color(0xFF636E72), fontWeight: FontWeight.w500)),
      ]),
    );
  }
}
