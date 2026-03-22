import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/types/business/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForwardPage extends StatelessWidget {
  const ForwardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: 'Forward to',
      showBack: true,
      child: Column(
        children: [
          _buildSearchBox(),
          Expanded(child: _buildContactList(context)),
        ],
      ),
    );
  }

  Widget _buildSearchBox() => Container(padding: EdgeInsets.all(12.w), child: Container(padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w), decoration: BoxDecoration(color: const Color(0xFFF1F2F6), borderRadius: BorderRadius.circular(8.w)), child: Row(children: [Icon(Icons.search, size: 20.w, color: const Color(0xFF99A3AD)), SizedBox(width: 8.w), Text('Search contacts', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF99A3AD)))])));

  Widget _buildContactList(BuildContext context) {
    final contacts = context.select<ContactStore, List<UserInfo>>((store) => store.state.userMap.values.toList());
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) => _buildContactItem(contacts[index]),
    );
  }

  Widget _buildContactItem(UserInfo user) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFFE9EDF2), width: 1.w))),
      child: Row(
        children: [
          BeaverCachedImage(fileKey: user.avatar, type: CacheType.avatar, width: 40.w, height: 40.w, borderRadius: 20.w, fit: BoxFit.cover),
          SizedBox(width: 12.w),
          Text(user.nickname, style: TextStyle(fontSize: 16.sp, color: const Color(0xFF2D3436))),
          const Spacer(),
          Icon(Icons.circle_outlined, size: 22.w, color: const Color(0xFFCBD2DA)),
        ],
      ),
    );
  }
}
