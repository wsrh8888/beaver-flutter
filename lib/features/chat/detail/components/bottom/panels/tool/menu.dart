import 'package:beaver/features/chat/detail/components/bottom/panels/tool/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToolMenu extends StatelessWidget {
  const ToolMenu({super.key});
  @override
  Widget build(BuildContext context) {
    // Audit check: photo, camera, phone, vedio, forward, reply, delete, save exist in assets/images/chat
    final List<Map<String, dynamic>> items = [
      {'icon': 'photo', 'label': '相册'},
      {'icon': 'camera', 'label': '拍摄'},
      {'icon': 'phone', 'label': '语音通话'},
      {'icon': 'vedio', 'label': '视频通话'},
      {'icon': 'location', 'label': '位置'},
      {'icon': 'transfer', 'label': '转账'},
      {'icon': 'file', 'label': '文件'},
      {'icon': 'card', 'label': '名片'},
    ];
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 20.w, crossAxisSpacing: 20.w, childAspectRatio: 0.7),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ToolItem(icon: item['icon'], label: item['label'], onTap: () {});
      },
    );
  }
}
