import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/button/button.dart';


class ContactDetailPage extends StatefulWidget {
  final String? userId; // 改为可空
  const ContactDetailPage({super.key, this.userId});

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '详细资料',
      showBack: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 24.w),
            _buildInfoList(),
            SizedBox(height: 32.w),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        children: [
          BeaverCachedImage(
            fileKey: '', // 头像地址
            type: CacheType.avatar,
            width: 64.w,
            height: 64.w,
            borderRadius: 32.w,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '张三',
                  style: TextStyle(
                    fontSize: 20.w,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  '账号: user_12345',
                  style: TextStyle(
                    fontSize: 14.w,
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

  Widget _buildInfoList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Column(
        children: [
          _buildInfoItem('备注名', '未设置'),
          _buildInfoItem('性别', '男'),
          _buildInfoItem('地区', '北京 朝阳'),
          _buildInfoItem('个性签名', '生命在于运动'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF1F2F6),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15.w, color: const Color(0xFF636E72))),
          Text(value, style: TextStyle(fontSize: 15.w, color: const Color(0xFF2D3436))),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        BeaverButton(
          text: '发消息',
          onPressed: () {},
          width: double.infinity,
        ),
        SizedBox(height: 12.w),
        BeaverButton(
          text: '音视频通话',
          type: BeaverButtonType.outline,
          onPressed: () {},
          width: double.infinity,
        ),
      ],
    );
  }
}
