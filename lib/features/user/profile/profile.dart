import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/user/profile/bloc/bloc.dart';
import 'package:beaver/features/user/profile/bloc/event.dart';
import 'package:beaver/features/user/profile/bloc/state.dart';
import 'package:beaver/features/user/profile/data/repositories/repository.dart';
import 'package:beaver/features/user/profile/components/nickname_dialog.dart';
import 'package:beaver/features/user/profile/components/email_dialog.dart';
import 'package:beaver/features/user/profile/components/bio_dialog.dart';
import 'package:beaver/features/user/profile/components/gender_dialog.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc _profileBloc;
  
  // 弹窗状态
  bool _showNicknameDialog = false;
  bool _showEmailDialog = false;
  bool _showBioDialog = false;
  bool _showGenderDialog = false;
  
  @override
  void initState() {
    super.initState();
    final repository = ProfileRepository();
    _profileBloc = ProfileBloc(repository)..add(LoadUserInfoEvent());
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
    // 实现头像选择逻辑
    // 这里可以使用image_picker库
    _profileBloc.add(UpdateAvatarEvent());
  }

  void _openModal(String type, ProfileState state) {
    setState(() {
      switch (type) {
        case 'nickname':
          _showNicknameDialog = true;
          break;
        case 'email':
          _showEmailDialog = true;
          break;
        case 'description':
          _showBioDialog = true;
          break;
        case 'gender':
          _showGenderDialog = true;
          break;
      }
    });
  }

  void _closeModal(String type) {
    setState(() {
      switch (type) {
        case 'nickname':
          _showNicknameDialog = false;
          break;
        case 'email':
          _showEmailDialog = false;
          break;
        case 'description':
          _showBioDialog = false;
          break;
        case 'gender':
          _showGenderDialog = false;
          break;
      }
    });
  }

  void _saveNickname(String nickname) {
    _profileBloc.add(UpdateFormDataEvent('nickname', nickname));
    _profileBloc.add(SaveNicknameEvent());
    _closeModal('nickname');
  }

  void _saveEmail(Map<String, String> data) {
    _profileBloc.add(UpdateFormDataEvent('email', data['email']!));
    _profileBloc.add(UpdateFormDataEvent('emailCode', data['code']!));
    _profileBloc.add(SendEmailCodeEvent());
    _profileBloc.add(SaveEmailEvent());
    _closeModal('email');
  }

  void _saveBio(String bio) {
    _profileBloc.add(UpdateFormDataEvent('bio', bio));
    _profileBloc.add(SaveBioEvent());
    _closeModal('description');
  }

  void _saveGender(int gender) {
    _profileBloc.add(UpdateFormDataEvent('gender', gender));
    _profileBloc.add(SaveGenderEvent());
    _closeModal('gender');
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

  void _showToast(String message) {
    BeaverToast.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.error) {
            _showToast(state.errorMessage ?? '发生错误');
          } else if (state.status == ProfileStatus.success) {
            _showToast('修改成功');
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              BeaverLayout(
                title: '编辑个人资料',
                showBack: true,
                onBack: _goBack,
                showBackground: false,
                isScrollable: true,
                child: Container(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    children: [
                      // 头像上传
                      GestureDetector(
                        onTap: _chooseAvatar,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 32.w),
                          padding: EdgeInsets.all(32.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: Offset(0, 16.w),
                                blurRadius: 40.w,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 160.w,
                                    height: 160.w,
                                    margin: EdgeInsets.symmetric(horizontal: 32.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF7D45).withOpacity(0.2),
                                          offset: Offset(0, 16.w),
                                          blurRadius: 40.w,
                                        ),
                                      ],
                                    ),
                                    child: BeaverAvatar(
                                    size: 160.w,
                                    name: state.userInfo?.nickName,
                                  ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    height: 48.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(40.w),
                                          bottomRight: Radius.circular(40.w),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '更换',
                                        style: TextStyle(
                                          fontSize: 22.w,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.w),
                              Text(
                                '点击更换头像',
                                style: TextStyle(
                                  fontSize: 26.w,
                                  color: const Color(0xFF636E72),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // 个人信息列表
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(0, 16.w),
                              blurRadius: 40.w,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // 昵称
                            GestureDetector(
                              onTap: () => _openModal('nickname', state),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color(0xFFF0F2F5),
                                      width: 2.w,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '昵称',
                                      style: TextStyle(
                                        fontSize: 30.w,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      state.userInfo?.nickName ?? '未设置',
                                      style: TextStyle(
                                        fontSize: 30.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                    SizedBox(width: 24.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 24.w,
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // 个人简介
                            GestureDetector(
                              onTap: () => _openModal('description', state),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color(0xFFF0F2F5),
                                      width: 2.w,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '个人简介',
                                          style: TextStyle(
                                            fontSize: 30.w,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF2D3436),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '编辑',
                                              style: TextStyle(
                                                fontSize: 26.w,
                                                color: const Color(0xFFFF7D45),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Icon(
                                              Icons.edit,
                                              size: 24.w,
                                              color: const Color(0xFFFF7D45),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.w),
                                    Text(
                                      state.userInfo?.abstract ?? '介绍一下自己，让更多人了解你',
                                      style: TextStyle(
                                        fontSize: 26.w,
                                        color: state.userInfo?.abstract == null 
                                            ? const Color(0xFFB2BEC3)
                                            : const Color(0xFF636E72),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // 邮箱
                            GestureDetector(
                              onTap: () => _openModal('email', state),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color(0xFFF0F2F5),
                                      width: 2.w,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '邮箱',
                                      style: TextStyle(
                                        fontSize: 30.w,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatEmail(state.userInfo?.email),
                                      style: TextStyle(
                                        fontSize: 30.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                    SizedBox(width: 24.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 24.w,
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // 性别
                            GestureDetector(
                              onTap: () => _openModal('gender', state),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.w),
                                child: Row(
                                  children: [
                                    Text(
                                      '性别',
                                      style: TextStyle(
                                        fontSize: 30.w,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      state.userInfo?.gender == 1 ? '男' : 
                                      state.userInfo?.gender == 2 ? '女' : '未设置',
                                      style: TextStyle(
                                        fontSize: 30.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                    SizedBox(width: 24.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 24.w,
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                  ],
                                ),
                              ),
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
              _showNicknameDialog ? NicknameDialog(
                initialValue: state.userInfo?.nickName ?? '',
                onSave: _saveNickname,
                onCancel: () => _closeModal('nickname'),
              ) : const SizedBox(),
              // 邮箱弹窗
              _showEmailDialog ? EmailDialog(
                onSave: _saveEmail,
                onCancel: () => _closeModal('email'),
              ) : const SizedBox(),
              // 个人简介弹窗
              _showBioDialog ? BioDialog(
                initialValue: state.userInfo?.abstract ?? '',
                onSave: _saveBio,
                onCancel: () => _closeModal('description'),
              ) : const SizedBox(),
              // 性别选择弹窗
              _showGenderDialog ? GenderDialog(
                initialValue: state.userInfo?.gender ?? 1,
                onSave: _saveGender,
                onCancel: () => _closeModal('gender'),
              ) : const SizedBox(),
            ],
          );
        },
      ),
    );
  }


}
