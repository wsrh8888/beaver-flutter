import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/profile/profile_page/bloc/bloc.dart';
import 'package:beaver/features/profile/profile_page/bloc/event.dart';
import 'package:beaver/features/profile/profile_page/bloc/state.dart';
import 'package:beaver/features/profile/profile_page/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc _profileBloc;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailCodeController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc(ProfileRepository())..add(LoadUserInfoEvent());
  }

  @override
  void dispose() {
    _profileBloc.close();
    _nicknameController.dispose();
    _emailController.dispose();
    _emailCodeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _openModal(String modalType) {
    _profileBloc.add(OpenModalEvent(modalType));
  }

  void _closeModal(String modalType) {
    _profileBloc.add(CloseModalEvent(modalType));
  }

  void _updateFormData(String key, dynamic value) {
    _profileBloc.add(UpdateFormDataEvent(key, value));
  }

  void _saveNickname() {
    _profileBloc.add(SaveNicknameEvent());
  }

  void _saveEmail() {
    _profileBloc.add(SaveEmailEvent());
  }

  void _saveBio() {
    _profileBloc.add(SaveBioEvent());
  }

  void _saveGender() {
    _profileBloc.add(SaveGenderEvent());
  }

  void _sendEmailCode() {
    _profileBloc.add(SendEmailCodeEvent());
  }

  void _updateAvatar() {
    _profileBloc.add(UpdateAvatarEvent());
  }

  String _formatEmail(String email) {
    // 简单的邮箱格式化
    return email;
  }

  String _getGenderText(int gender) {
    switch (gender) {
      case 1:
        return '男';
      case 2:
        return '女';
      default:
        return '未设置';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          } else if (state.status == ProfileStatus.success && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
          // 更新控制器
          if (state.formData.containsKey('nickname')) {
            _nicknameController.text = state.formData['nickname'] ?? '';
          }
          if (state.formData.containsKey('email')) {
            _emailController.text = state.formData['email'] ?? '';
          }
          if (state.formData.containsKey('emailCode')) {
            _emailCodeController.text = state.formData['emailCode'] ?? '';
          }
          if (state.formData.containsKey('bio')) {
            _bioController.text = state.formData['bio'] ?? '';
          }
        },
        builder: (context, state) {
          final userInfo = state.userInfo;

          return BeaverLayout(
            title: '编辑个人资料',
            showBack: true,
            showBackground: false,
            isScrollable: true,
            child: Column(
              children: [
                // 安全距离
                Container(height: 20.w),
                // 头像上传
                GestureDetector(
                  onTap: _updateAvatar,
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 12.w),
                          child: Stack(
                            children: [
                              BeaverAvatar(
                                url: userInfo?.fileName ?? '',
                                size: 120.w,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF7D45),
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  child: Text(
                                    '更换',
                                    style: TextStyle(
                                      fontSize: 12.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '点击更换头像',
                          style: TextStyle(
                            fontSize: 14.w,
                            color: const Color(0xFF636E72),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 个人信息列表
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: Offset(0, 4.w),
                        blurRadius: 12.w,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 昵称
                      GestureDetector(
                        onTap: () => _openModal('nickname'),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFFEBEEF5),
                                width: 1.w,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '昵称',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    userInfo?.nickName ?? '',
                                    style: TextStyle(
                                      fontSize: 16.w,
                                      color: const Color(0xFF636E72),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                    color: const Color(0xFFB2BEC3),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 个人简介
                      GestureDetector(
                        onTap: () => _openModal('description'),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFFEBEEF5),
                                width: 1.w,
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
                                      fontSize: 16.w,
                                      color: const Color(0xFF2D3436),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '编辑',
                                        style: TextStyle(
                                          fontSize: 14.w,
                                          color: const Color(0xFFFF7D45),
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.edit,
                                        size: 14.w,
                                        color: const Color(0xFFFF7D45),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.w),
                              Text(
                                userInfo?.abstract ?? '介绍一下自己，让更多人了解你',
                                style: TextStyle(
                                  fontSize: 14.w,
                                  color: userInfo?.abstract != null
                                      ? const Color(0xFF636E72)
                                      : const Color(0xFFB2BEC3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 邮箱
                      GestureDetector(
                        onTap: () => _openModal('email'),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFFEBEEF5),
                                width: 1.w,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '邮箱',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _formatEmail(userInfo?.email ?? ''),
                                    style: TextStyle(
                                      fontSize: 16.w,
                                      color: const Color(0xFF636E72),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                    color: const Color(0xFFB2BEC3),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 性别
                      GestureDetector(
                        onTap: () => _openModal('gender'),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '性别',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _getGenderText(userInfo?.gender ?? 3),
                                    style: TextStyle(
                                      fontSize: 16.w,
                                      color: const Color(0xFF636E72),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                    color: const Color(0xFFB2BEC3),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
