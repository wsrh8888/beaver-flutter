import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/user/profile/bloc/bloc.dart';
import 'package:beaver/features/user/profile/bloc/event.dart';
import 'package:beaver/features/user/profile/bloc/state.dart';
import 'package:beaver/features/user/profile/components/nickname_dialog.dart';
import 'package:beaver/features/user/profile/components/email_dialog.dart';
import 'package:beaver/features/user/profile/components/bio_dialog.dart';
import 'package:beaver/features/user/profile/components/gender_dialog.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc _profileBloc;
  
  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc()..add(LoadUserInfoEvent());
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _chooseAvatar() {
    _profileBloc.add(UpdateAvatarEvent());
  }

  void _openModal(String type) {
    _profileBloc.add(OpenModalEvent(type));
  }

  void _closeModal(String type) {
    _profileBloc.add(CloseModalEvent(type));
  }

  void _saveNickname(String nickname) {
    _profileBloc.add(UpdateFormDataEvent('nickname', nickname));
    _profileBloc.add(SaveNicknameEvent());
  }

  void _saveEmail(Map<String, String> data) {
    _profileBloc.add(UpdateFormDataEvent('email', data['email']!));
    _profileBloc.add(UpdateFormDataEvent('emailCode', data['code']!));
    _profileBloc.add(SaveEmailEvent());
  }

  void _saveBio(String bio) {
    _profileBloc.add(UpdateFormDataEvent('bio', bio));
    _profileBloc.add(SaveBioEvent());
  }

  void _saveGender(int gender) {
    _profileBloc.add(UpdateFormDataEvent('gender', gender));
    _profileBloc.add(SaveGenderEvent());
  }

  String _formatEmail(String? email) {
    if (email == null || email.isEmpty) return '未设置';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 2) return email;
    return '${username.substring(0, 2)}***@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.error && state.errorMessage != null) {
            BeaverToast.show(context, state.errorMessage!);
          } else if (state.status == ProfileStatus.success && state.errorMessage != null) {
             BeaverToast.show(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          final userInfo = state.userInfo;

          return Stack(
            children: [
              BeaverLayout(
                title: '编辑个人资料',
                showBack: true,
                onBack: _goBack,
                showBackground: false,
                isScrollable: true,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.w),
                  child: Column(
                    children: [
                      // 头像上传区域
                      Center(
                        child: GestureDetector(
                          onTap: _chooseAvatar,
                          child: Container(
                            width: 80.w, // uniapp 80px
                            height: 80.w,
                            margin: EdgeInsets.only(bottom: 24.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.w), // uniapp 20px
                              color: const Color(0xFFF0F2F5),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                BeaverCachedImage(
                                  width: 80.w,
                                  height: 80.w,
                                  fileKey: userInfo?.avatar,
                                  type: CacheType.avatar,
                                  borderRadius: 20.w,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 24.w,
                                    color: Colors.black.withOpacity(0.4),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '更换',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp, // uniapp 20rpx
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // 个人信息列表
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.w), // 20px
                        ),
                        child: Column(
                          children: [
                            _buildInfoItem(
                              label: '昵称',
                              value: userInfo?.nickname ?? '未设置',
                              onTap: () => _openModal('nickname'),
                            ),
                            _buildDivider(),
                            _buildBioItem(
                              value: userInfo?.abstract,
                              onTap: () => _openModal('description'),
                            ),
                            _buildDivider(),
                            _buildInfoItem(
                              label: '邮箱',
                              value: _formatEmail(userInfo?.email),
                              onTap: () => _openModal('email'),
                            ),
                            _buildDivider(),
                            _buildInfoItem(
                              label: '性别',
                              value: userInfo?.gender == 1 ? '男' : 
                                     userInfo?.gender == 2 ? '女' : '未设置',
                              onTap: () => _openModal('gender'),
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 48.w),
                    ],
                  ),
                ),
              ),
              
              // 昵称弹窗
              if (state.modals['nickname'] ?? false)
                NicknameDialog(
                  initialValue: userInfo?.nickname ?? '',
                  onSave: _saveNickname,
                  onCancel: () => _closeModal('nickname'),
                ),
              
              // 邮箱弹窗
              if (state.modals['email'] ?? false)
                EmailDialog(
                  onSave: _saveEmail,
                  onCancel: () => _closeModal('email'),
                ),
                
              // 个人简介弹窗
              if (state.modals['description'] ?? false)
                BioDialog(
                  initialValue: userInfo?.abstract ?? '',
                  onSave: _saveBio,
                  onCancel: () => _closeModal('description'),
                ),
                
              // 性别选择弹窗
              if (state.modals['gender'] ?? false)
                GenderDialog(
                  initialValue: userInfo?.gender ?? 0,
                  onSave: _saveGender,
                  onCancel: () => _closeModal('gender'),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56.w, // uniapp 112rpx? actually uniapp doesn't specify height but padding
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp, // uniapp 15px
                color: const Color(0xFF333333),
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp, // uniapp 14px
                color: const Color(0xFF999999),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.w,
              color: const Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioItem({
    String? value,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '个人简介',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Row(
                  children: [
                    Text(
                      '编辑',
                      style: TextStyle(
                        fontSize: 13.sp, // uniapp 13px
                        color: const Color(0xFFFE7B07),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.edit,
                      size: 14.w,
                      color: const Color(0xFFFE7B07),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.w),
          Text(
            (value == null || value.isEmpty) ? '介绍一下自己，让更多人了解你' : value,
            style: TextStyle(
              fontSize: 14.sp,
              color: (value == null || value.isEmpty) 
                  ? const Color(0xFFCCCCCC)
                  : const Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 0.5.w, // uniapp 1rpx
      color: const Color(0xFFEEEEEE),
    );
  }
}
