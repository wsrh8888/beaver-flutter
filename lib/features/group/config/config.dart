import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/group/config/bloc/bloc.dart';
import 'package:beaver/features/group/config/bloc/event.dart';
import 'package:beaver/features/group/config/bloc/state.dart';
import 'package:beaver/features/group/config/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class GroupConfigPage extends StatefulWidget {
  const GroupConfigPage({super.key});

  @override
  State<GroupConfigPage> createState() => _GroupConfigPageState();
}

class _GroupConfigPageState extends State<GroupConfigPage> {
  late GroupConfigBloc _groupConfigBloc;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _groupConfigBloc = GroupConfigBloc(GroupConfigRepository());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 假设从路由参数获�?groupId
      _groupConfigBloc.add(LoadGroupInfoEvent('123'));
    });
  }

  @override
  void dispose() {
    _groupConfigBloc.close();
    _nameController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _openNameModal() {
    _groupConfigBloc.add(OpenNameModalEvent());
  }

  void _closeNameModal() {
    _groupConfigBloc.add(CloseNameModalEvent());
  }

  void _updateGroupName(String name) {
    _groupConfigBloc.add(UpdateGroupNameEvent(name));
  }

  void _saveGroupName() {
    _groupConfigBloc.add(SaveGroupNameEvent());
  }

  void _navigateToGroupMember(String mode) {
    _groupConfigBloc.add(NavigateToGroupMemberEvent(mode));
  }

  void _exitGroup() {
    _groupConfigBloc.add(ExitGroupEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _groupConfigBloc,
      child: BlocConsumer<GroupConfigBloc, GroupConfigState>(
        listener: (context, state) {
          if (state.status == GroupConfigStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          } else if (state.status == GroupConfigStatus.success && state.errorMessage != null) {
            BeaverToast.show(context, state.errorMessage!);
            if (state.errorMessage == '已退出群聊') {
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            }
          }
          // 更新控制�?
          _nameController.text = state.groupName;
        },
        builder: (context, state) {
          final groupInfo = state.groupInfo;
          final displayMembers = state.groupMembers.take(9).toList();

          return Stack(
            children: [
              BeaverLayout(
                title: '群聊详情',
                showBack: true,
                showBackground: false,
                isScrollable: true,
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      // 群组信息
                      if (groupInfo != null)
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  BeaverAvatar(
                                    url: groupInfo.fileName,
                                    size: 64.w,
                                  ),
                                  if (state.isAdmin)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF7D45),
                                          borderRadius: BorderRadius.circular(8.w),
                                        ),
                                        child: Text(
                                          '更换',
                                          style: TextStyle(
                                            fontSize: 10.w,
                                            color: Colors.white,
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
                                      groupInfo.title,
                                      style: TextStyle(
                                        fontSize: 18.w,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                    SizedBox(height: 4.w),
                                    Text(
                                      '${groupInfo.memberCount}�?,
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
                      // 群成员区�?
                      Container(
                        margin: EdgeInsets.only(bottom: 24.w),
                        padding: EdgeInsets.all(20.w),
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
                            // 成员头部
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.group,
                                      size: 20.w,
                                      color: const Color(0xFFFF7D45),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '群成�?,
                                      style: TextStyle(
                                        fontSize: 16.w,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => _navigateToGroupMember('view'),
                                  child: Text(
                                    '${state.groupMembers.length}�?,
                                    style: TextStyle(
                                      fontSize: 14.w,
                                      color: const Color(0xFFFF7D45),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.w),
                            // 成员网格
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.w,
                                childAspectRatio: 1,
                              ),
                              itemCount: displayMembers.length + (state.isAdmin ? 2 : 0),
                              itemBuilder: (context, index) {
                                if (index < displayMembers.length) {
                                  return _buildMemberItem(displayMembers[index]);
                                } else if (index == displayMembers.length && state.isAdmin) {
                                  return _buildAddMemberItem();
                                } else {
                                  return _buildRemoveMemberItem();
                                }
                              },
                            ),
                            SizedBox(height: 16.w),
                            // 查看全部
                            GestureDetector(
                              onTap: () => _navigateToGroupMember('view'),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.w),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '查看全部成员',
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12.w,
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 功能列表
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
                          onTap: _openNameModal,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
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
                                        Icons.edit,
                                        size: 20.w,
                                        color: const Color(0xFFFF7D45),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '群聊名称',
                                          style: TextStyle(
                                            fontSize: 16.w,
                                            color: const Color(0xFF2D3436),
                                          ),
                                        ),
                                        Text(
                                          '修改群组的显示名�?,
                                          style: TextStyle(
                                            fontSize: 12.w,
                                            color: const Color(0xFFB2BEC3),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      groupInfo?.title ?? '',
                                      style: TextStyle(
                                        fontSize: 14.w,
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
                      ),
                    ],
                  ),
                ),
              ),
              // 修改群名称弹�?
              if (state.showNameModal)
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
                        // 标题
                        Text(
                          '修改群名�?,
                          style: TextStyle(
                            fontSize: 18.w,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        SizedBox(height: 24.w),
                        // 输入�?
                        TextField(
                          controller: _nameController,
                          onChanged: _updateGroupName,
                          maxLength: 20,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.w),
                              borderSide: BorderSide(
                                color: const Color(0xFFE0E0E0),
                                width: 1.w,
                              ),
                            ),
                            hintText: '请输入群名称',
                            hintStyle: TextStyle(
                              fontSize: 14.w,
                              color: const Color(0xFFB2BEC3),
                            ),
                            counterText: '',
                          ),
                        ),
                        SizedBox(height: 8.w),
                        // 字数统计
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${state.groupName.length}/20',
                            style: TextStyle(
                              fontSize: 12.w,
                              color: const Color(0xFFB2BEC3),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.w),
                        // 按钮
                        GestureDetector(
                          onTap: _saveGroupName,
                          child: Container(
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7D45),
                              borderRadius: BorderRadius.circular(24.w),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '确定',
                              style: TextStyle(
                                fontSize: 16.w,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // 退出群聊按�?
              Positioned(
                left: 0,
                right: 0,
                bottom: 24.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: GestureDetector(
                    onTap: _exitGroup,
                    child: Container(
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF44336),
                        borderRadius: BorderRadius.circular(24.w),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '退出群�?,
                        style: TextStyle(
                          fontSize: 16.w,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMemberItem(member) {
    return Column(
      children: [
        BeaverAvatar(
          url: member.fileName,
          size: 48.w,
        ),
        SizedBox(height: 4.w),
        Text(
          member.nickname,
          style: TextStyle(
            fontSize: 10.w,
            color: const Color(0xFF2D3436),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAddMemberItem() {
    return GestureDetector(
      onTap: () => _navigateToGroupMember('add'),
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(24.w),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 24.w,
              color: const Color(0xFF4CAF50),
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            '添加',
            style: TextStyle(
              fontSize: 10.w,
              color: const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveMemberItem() {
    return GestureDetector(
      onTap: () => _navigateToGroupMember('remove'),
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF5E8E8),
              borderRadius: BorderRadius.circular(24.w),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.remove,
              size: 24.w,
              color: const Color(0xFFF44336),
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            '移除',
            style: TextStyle(
              fontSize: 10.w,
              color: const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }
}

