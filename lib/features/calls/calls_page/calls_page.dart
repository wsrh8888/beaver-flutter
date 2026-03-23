import 'package:flutter/material.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BeaverLayout(
      title: '通话',
      showBack: true,
      child: Center(child: Text('通话记录')),
    );
  }
}
