import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/group/config/bloc/bloc.dart';
import 'package:beaver/features/group/config/bloc/event.dart';
import 'package:beaver/features/group/config/bloc/state.dart';
import 'package:beaver/features/group/config/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
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
      _groupConfigBloc.add(LoadGroupInfoEvent('123'));
    });
  }

  @override
  void dispose() {
    _groupConfigBloc.close();
    _nameController.dispose();
    super.dispose();
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
                isScrollable: true,
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      if (groupInfo != null)
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          child: Row(
                            children: [
                              BeaverAvatar(
                                url: groupInfo.fileName,
                                size: 64.w,
                                nickname: groupInfo.title,
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
                                      '${groupInfo.memberCount}人',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.group, size: 20.w, color: const Color(0xFFFF7D45)),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '群成员',
                                      style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436)),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${state.groupMembers.length}人',
                                  style: TextStyle(fontSize: 14.w, color: const Color(0xFFFF7D45)),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.w),
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
                                  return _buildActionButton(Icons.add, '添加', const Color(0xFF4CAF50), const Color(0xFFE8F5E8));
                                } else {
                                  return _buildActionButton(Icons.remove, '移除', const Color(0xFFF44336), const Color(0xFFF5E8E8));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      _buildMenuItem('群聊名称', state.groupName, onTap: () => _groupConfigBloc.add(OpenNameModalEvent())),
                      SizedBox(height: 48.w),
                      GestureDetector(
                        onTap: () => _groupConfigBloc.add(ExitGroupEvent()),
                        child: Container(
                          height: 48.w,
                          decoration: BoxDecoration(color: const Color(0xFFF44336), borderRadius: BorderRadius.circular(24.w)),
                          alignment: Alignment.center,
                          child: Text('退出群聊', style: TextStyle(fontSize: 16.w, color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.showNameModal) _buildNameEditModal(state.groupName),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(String title, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.w)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16.w, color: const Color(0xFF2D3436))),
            Row(
              children: [
                Text(value, style: TextStyle(fontSize: 14.w, color: const Color(0xFF636E72))),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward_ios, size: 16.w, color: const Color(0xFFB2BEC3)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberItem(member) {
    return Column(
      children: [
        BeaverAvatar(url: member.fileName, size: 48.w, nickname: member.nickname),
        SizedBox(height: 4.w),
        Text(member.nickname, style: TextStyle(fontSize: 10.w, color: const Color(0xFF2D3436)), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color iconColor, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(24.w)),
          alignment: Alignment.center,
          child: Icon(icon, size: 24.w, color: iconColor),
        ),
        SizedBox(height: 4.w),
        Text(label, style: TextStyle(fontSize: 10.w, color: const Color(0xFF2D3436))),
      ],
    );
  }

  Widget _buildNameEditModal(String currentName) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.w)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('修改群名称', style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
            SizedBox(height: 24.w),
            TextField(
              controller: _nameController,
              maxLength: 20,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w)),
                hintText: '请输入群名称',
              ),
            ),
            SizedBox(height: 24.w),
            Row(
              children: [
                Expanded(child: TextButton(onPressed: () => _groupConfigBloc.add(CloseNameModalEvent()), child: const Text('取消'))),
                Expanded(child: ElevatedButton(onPressed: () => _groupConfigBloc.add(SaveGroupNameEvent()), child: const Text('确定'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
