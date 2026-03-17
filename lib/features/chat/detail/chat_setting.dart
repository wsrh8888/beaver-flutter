import 'package:flutter/material.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class ChatSettingPage extends StatelessWidget {
  const ChatSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BeaverLayout(
      title: '聊天设置',
      showBack: true,
      child: Center(
        child: Text('聊天设置页面开发中'),
      ),
    );
  }
}
