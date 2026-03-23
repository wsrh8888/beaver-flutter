import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class MomentDetailPage extends StatefulWidget {
  final String? momentId;
  const MomentDetailPage({super.key, this.momentId});

  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '动态详情',
      showBack: true,
      child: Center(
        child: Text('动态详情: ${widget.momentId ?? ""}'),
      ),
    );
  }
}
