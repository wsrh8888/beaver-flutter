import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/user/config/bloc/bloc.dart';
import 'package:beaver/features/user/config/bloc/event.dart';
import 'package:beaver/features/user/config/bloc/state.dart';
import 'package:beaver/features/user/config/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key});

  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  late UserConfigBloc _userConfigBloc;

  @override
  void initState() {
    super.initState();
    _userConfigBloc = UserConfigBloc(UserConfigRepository());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 假设从路由参数获取conversationId
      _userConfigBloc.add(LoadFriendInfoEvent('123'));
    });
  }

  @override
  void dispose() {
    _userConfigBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _toggleTopChat() {
    _userConfigBloc.add(ToggleTopChatEvent());
  }

  void _showDeleteModal() {
    _userConfigBloc.add(ShowDeleteModalEvent());
  }

  void _hideDeleteModal() {
    _userConfigBloc.add(HideDeleteModalEvent());
  }

  void _confirmDelete() {
    _userConfigBloc.add(ConfirmDeleteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userConfigBloc,
      child: BlocConsumer<UserConfigBloc, UserConfigState>(
        listener: (context, state) {
          if (state.status == UserConfigStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          } else if (state.status == UserConfigStatus.success && state.errorMessage != null) {
            BeaverToast.show(context, state.errorMessage!);
            if (state.errorMessage == '删除成功') {
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            }
          }
        },
        builder: (context, state) {
          final friendInfo = state.friendInfo;

          return Stack(
            children: [
              BeaverLayout(
                title: '聊天详情',
                showBack: true,
                showBackground: false,
                isScrollable: true,
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      // 用户信息卡片
                      if (friendInfo != null)
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          padding: EdgeInsets.all(24.w),
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
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  BeaverAvatar(
                                    url: friendInfo.fileName,
                                    size: 64.w,
                                  ),
                                  if (friendInfo.isOnline)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 16.w,
                                        height: 16.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4CAF50),
                                          borderRadius: BorderRadius.circular(8.w),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      friendInfo.nickname,
                                      style: TextStyle(
                                        fontSize: 18.w,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                    SizedBox(height: 4.w),
                                    Text(
                                      'ID: ${friendInfo.userId}',
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: const Color(0xFFB2BEC3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      // 聊天设置
                      Container(
                        margin: EdgeInsets.only(bottom: 24.w),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 标题
                            Container(
                              padding: EdgeInsets.all(20.w),
                              child: Text(
                                '聊天设置',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                            ),
                            // 置顶聊天
                            GestureDetector(
                              onTap: _toggleTopChat,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 16.w,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40.w,
                                          height: 40.w,
                                          margin: EdgeInsets.only(right: 12.w),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFE6D9),
                                            borderRadius: BorderRadius.circular(10.w),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.push_pin,
                                            size: 20.w,
                                            color: const Color(0xFFFF7D45),
                                          ),
                                        ),
                                        Text(
                                          '置顶聊天',
                                          style: TextStyle(
                                            fontSize: 16.w,
                                            color: const Color(0xFF2D3436),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // 开?
                                    GestureDetector(
                                      onTap: _toggleTopChat,
                                      child: Container(
                                        width: 48.w,
                                        height: 28.w,
                                        decoration: BoxDecoration(
                                          color: state.isTopChat
                                              ? const Color(0xFFFF7D45)
                                              : const Color(0xFFE0E0E0),
                                          borderRadius: BorderRadius.circular(14.w),
                                        ),
                                        child: AnimatedAlign(
                                          duration: const Duration(milliseconds: 200),
                                          alignment: state.isTopChat
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            width: 24.w,
                                            height: 24.w,
                                            margin: EdgeInsets.symmetric(horizontal: 2.w),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12.w),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 危险操作
                      Container(
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
                        child: GestureDetector(
                          onTap: _showDeleteModal,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.w,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  margin: EdgeInsets.only(right: 12.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE6E6),
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: 20.w,
                                    color: const Color(0xFFF44336),
                                  ),
                                ),
                                Text(
                                  '删除好友',
                                  style: TextStyle(
                                    fontSize: 16.w,
                                    color: const Color(0xFFF44336),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 删除确认弹窗
              if (state.showDeleteModal)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.w),
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.w),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 图标
                        Container(
                          margin: EdgeInsets.only(bottom: 16.w),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 48.w,
                            color: const Color(0xFFFF7D45),
                          ),
                        ),
                        // 标题
                        Text(
                          '删除好友',
                          style: TextStyle(
                            fontSize: 18.w,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        SizedBox(height: 16.w),
                        // 内容
                        Text(
                          '确定要删除好友"${friendInfo?.nickname ?? '未知用户'}" 吗？',
                          style: TextStyle(
                            fontSize: 14.w,
                            color: const Color(0xFF2D3436),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          '删除后将无法恢复，聊天记录也会被清空',
                          style: TextStyle(
                            fontSize: 12.w,
                            color: const Color(0xFFB2BEC3),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.w),
                        // 按钮
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _hideDeleteModal,
                                child: Container(
                                  height: 48.w,
                                  margin: EdgeInsets.only(right: 12.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F2F5),
                                    borderRadius: BorderRadius.circular(24.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                      fontSize: 16.w,
                                      color: const Color(0xFF636E72),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: _confirmDelete,
                                child: Container(
                                  height: 48.w,
                                  margin: EdgeInsets.only(left: 12.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF44336),
                                    borderRadius: BorderRadius.circular(24.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '删除',
                                    style: TextStyle(
                                      fontSize: 16.w,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

