import 'package:flutter/material.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class AddContactPage extends StatelessWidget {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BeaverLayout(
      title: '添加联系人',
      showBack: true,
      child: Center(
        child: Text('添加联系人页面开发中'),
      ),
    );
  }
}
