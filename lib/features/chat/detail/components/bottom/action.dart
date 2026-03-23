import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiSelectAction extends StatelessWidget {
  const MultiSelectAction({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.w + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: const Color(0xFFE9EDF2), width: 1.w))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildActionButton(Icons.reply_outlined, '转发', () {}),
        _buildActionButton(Icons.star_outline, '收藏', () {}),
        _buildActionButton(Icons.delete_outline, '删除', () {}),
        _buildActionButton(Icons.more_horiz, '更多', () {}),
      ]),
    );
  }
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 24.w, color: const Color(0xFF2D3436)), SizedBox(height: 4.w), Text(label, style: TextStyle(fontSize: 10.sp, color: const Color(0xFF636E72)))]));
}
