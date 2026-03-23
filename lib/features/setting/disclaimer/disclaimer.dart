import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:url_launcher/url_launcher.dart';

class DisclaimerPage extends StatefulWidget {
  const DisclaimerPage({super.key});

  @override
  State<DisclaimerPage> createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '免责声明',
      showBack: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '本项目仅用于技术学习、测试和演示目的，不涉及对外营业。欢迎学习交流！',
              style: TextStyle(
                fontSize: 16.w,
                color: const Color(0xFF2D3436),
                height: 1.6,
              ),
            ),
            SizedBox(height: 24.w),
            // 其他内容
          ],
        ),
      ),
    );
  }
}