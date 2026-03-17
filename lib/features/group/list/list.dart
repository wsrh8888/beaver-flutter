import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/group/list/bloc/bloc.dart';
import 'package:beaver/features/group/list/bloc/event.dart';
import 'package:beaver/features/group/list/bloc/state.dart';
import 'package:beaver/features/group/list/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  late GroupListBloc _groupListBloc;

  @override
  void initState() {
    super.initState();
    _groupListBloc = GroupListBloc(GroupListRepository())..add(LoadGroupListEvent());
  }

  @override
  void dispose() {
    _groupListBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _handleClickGroup(String conversationId) {
    _groupListBloc.add(SelectGroupEvent(conversationId));
  }

  void _createGroup() {
    _groupListBloc.add(CreateGroupEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _groupListBloc,
      child: BlocConsumer<GroupListBloc, GroupListState>(
        listener: (context, state) {
          if (state.status == GroupListStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              BeaverLayout(
                title: '我的群聊',
                showBack: true,
                showBackground: false,
                isScrollable: true,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      // 群聊列表
                      ...state.groupList.map((group) => GestureDetector(
                            onTap: () => _handleClickGroup(group.conversationId),
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              margin: EdgeInsets.only(bottom: 12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    offset: Offset(0, 2.w),
                                    blurRadius: 8.w,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.04),
                                  width: 1.w,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // 群聊头像
                                  Container(
                                    width: 48.w,
                                    height: 48.w,
                                    margin: EdgeInsets.only(right: 16.w),
                                    child: BeaverAvatar(
                                      url: group.fileName,
                                      size: 48.w,
                                    ),
                                  ),
                                  // 群聊信息
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 群聊名称
                                        Text(
                                          group.title,
                                          style: TextStyle(
                                            fontSize: 16.w,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF2D3436),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6.w),
                                        // 最后一条消�?
                                        Text(
                                          group.lastMessage ?? '',
                                          style: TextStyle(
                                            fontSize: 14.w,
                                            color: const Color(0xFF636E72),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6.w),
                                        // 成员数量
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.group,
                                              size: 14.w,
                                              color: const Color(0xFFB2BEC3),
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              '${group.memberCount}�?,
                                              style: TextStyle(
                                                fontSize: 12.w,
                                                color: const Color(0xFFB2BEC3),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              // 创建群聊按钮
              Positioned(
                bottom: 32.w,
                right: 32.w,
                child: GestureDetector(
                  onTap: _createGroup,
                  child: Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7D45),
                      borderRadius: BorderRadius.circular(28.w),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7D45).withOpacity(0.3),
                          offset: Offset(0, 4.w),
                          blurRadius: 12.w,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      size: 28.w,
                      color: Colors.white,
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
}

