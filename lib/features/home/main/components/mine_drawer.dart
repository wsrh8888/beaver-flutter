import 'package:flutter/material.dart';
import 'package:beaver/features/user/mine/mine.dart';

/// 主界面侧边栏「我的」面板，由 MainScreen Drawer 承载。
class MineDrawerPanel extends StatelessWidget {
  const MineDrawerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(color: Color(0xFFF9FAFB), child: MinePage());
  }
}
