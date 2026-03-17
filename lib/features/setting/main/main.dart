import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/main/bloc/bloc.dart';
import 'package:beaver/features/setting/main/bloc/event.dart';
import 'package:beaver/features/setting/main/bloc/state.dart';
import 'package:beaver/features/setting/main/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:go_router/go_router.dart';

class SettingMainPage extends StatefulWidget {
  const SettingMainPage({super.key});

  @override
  State<SettingMainPage> createState() => _SettingMainPageState();
}

class _SettingMainPageState extends State<SettingMainPage> {
  late SettingMainBloc _settingMainBloc;

  @override
  void initState() {
    super.initState();
    _settingMainBloc = SettingMainBloc(SettingMainRepository())..add(LoadSettingItemsEvent());
  }

  @override
  void dispose() {
    _settingMainBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _settingMainBloc,
      child: BlocConsumer<SettingMainBloc, SettingMainState>(
        listener: (context, state) {
          if (state.status == SettingMainStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? "错误");
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '设置',
            showBack: true,
            child: ListView(
              children: [
                _buildProfileItem(state),
                SizedBox(height: 12.w),
                ...state.settingItems.map((item) => _buildMenuItem(item)),
                SizedBox(height: 24.w),
                _buildLogoutButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(SettingMainState state) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          BeaverAvatar(url: '', size: 64.w, nickname: '用户'),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('用户昵称', style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold)),
                Text('账号: beaver_123', style: TextStyle(fontSize: 14.w, color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.qr_code, size: 24.w, color: Colors.grey),
          Icon(Icons.arrow_forward_ios, size: 16.w, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMenuItem(dynamic item) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(item.title, style: TextStyle(fontSize: 16.w)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
        onTap: () => context.push(item.route),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      color: Colors.white,
      child: TextButton(
        onPressed: _showLogoutDialog,
        child: const Text('退出登录', style: TextStyle(color: Colors.red)),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确认退出当前登录状态吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(onPressed: () {}, child: const Text('确认', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
