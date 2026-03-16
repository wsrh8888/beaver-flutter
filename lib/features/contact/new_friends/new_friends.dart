import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/contact/new_friends/bloc/bloc.dart';
import 'package:beaver/features/contact/new_friends/bloc/event.dart';
import 'package:beaver/features/contact/new_friends/bloc/state.dart';
import 'package:beaver/features/contact/new_friends/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';

class NewFriendsPage extends StatefulWidget {
  const NewFriendsPage({super.key});

  @override
  State<NewFriendsPage> createState() => _NewFriendsPageState();
}

class _NewFriendsPageState extends State<NewFriendsPage> {
  late NewFriendsBloc _newFriendsBloc;

  @override
  void initState() {
    super.initState();
    _newFriendsBloc = NewFriendsBloc(NewFriendsRepository())..add(LoadFriendRequestsEvent());
  }

  @override
  void dispose() {
    _newFriendsBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _switchTab(String tab) {
    _newFriendsBloc.add(SwitchTabEvent(tab));
  }

  void _acceptRequest(int id) {
    _newFriendsBloc.add(AcceptRequestEvent(id));
  }

  void _rejectRequest(int id) {
    _newFriendsBloc.add(RejectRequestEvent(id));
  }

  String _getSourceText(String source) {
    final sourceMap = {
      'search': '搜索',
      'qrcode': '二维�?,
      'group': '群聊',
      'card': '名片',
      'link': '链接',
      'other': '其他',
    };
    return sourceMap[source] ?? source;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _newFriendsBloc,
      child: BlocConsumer<NewFriendsBloc, NewFriendsState>(
        listener: (context, state) {
          if (state.status == NewFriendsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          } else if (state.status == NewFriendsStatus.success) {
            // 成功状态处�?
          }
        },
        builder: (context, state) {
          final filteredRequests = state.friendRequests.where((request) {
            if (state.activeTab == 'received') {
              return request.flag == 'receive';
            } else {
              return request.flag == 'send';
            }
          }).toList();

          final receivedCount = state.friendRequests.where((request) {
            return request.flag == 'receive' && request.status == 0;
          }).length;

          return BeaverLayout(
            title: '新的朋友',
            showBack: true,
            showBackground: false,
            isScrollable: true,
            child: Column(
              children: [
                // 分类标签
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  marginBottom: 16.w,
                  child: Row(
                    children: [
                      // 收到的申�?
                      GestureDetector(
                        onTap: () => _switchTab('received'),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.w),
                          child: Row(
                            children: [
                              Text(
                                '收到的申�?,
                                style: TextStyle(
                                  fontSize: 16.w,
                                  color: state.activeTab == 'received'
                                      ? const Color(0xFFFF7D45)
                                      : const Color(0xFF636E72),
                                  fontWeight: state.activeTab == 'received'
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              if (receivedCount > 0)
                                Container(
                                  margin: EdgeInsets.only(left: 8.w),
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF7D45),
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  child: Text(
                                    '$receivedCount',
                                    style: TextStyle(
                                      fontSize: 12.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // 发出的申�?
                      GestureDetector(
                        onTap: () => _switchTab('sent'),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.w),
                          child: Text(
                            '发出的申�?,
                            style: TextStyle(
                              fontSize: 16.w,
                              color: state.activeTab == 'sent'
                                  ? const Color(0xFFFF7D45)
                                  : const Color(0xFF636E72),
                              fontWeight: state.activeTab == 'sent'
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 分割�?
                Container(
                  height: 1.w,
                  color: const Color(0xFFEBEEF5),
                ),
                // 好友申请列表
                if (filteredRequests.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFFEBEEF5),
                                width: 1.w,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // 头像
                              Container(
                                margin: EdgeInsets.only(right: 16.w),
                                child: BeaverAvatar(
                                  url: request.fileName,
                                  size: 48.w,
                                ),
                              ),
                              // 内容
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 头部
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          request.nickname,
                                          style: TextStyle(
                                            fontSize: 16.w,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF2D3436),
                                          ),
                                        ),
                                        if (request.source.isNotEmpty)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 2.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF0F2F5),
                                              borderRadius: BorderRadius.circular(10.w),
                                            ),
                                            child: Text(
                                              _getSourceText(request.source),
                                              style: TextStyle(
                                                fontSize: 12.w,
                                                color: const Color(0xFF636E72),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 8.w),
                                    // 消息
                                    Text(
                                      request.message ?? '请求加为好友',
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                    SizedBox(height: 8.w),
                                    // 时间
                                    Text(
                                      request.createdAt,
                                      style: TextStyle(
                                        fontSize: 12.w,
                                        color: const Color(0xFFB2BEC3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 操作
                              Container(
                                margin: EdgeInsets.only(left: 16.w),
                                child: request.flag == 'receive'
                                    ? request.status == 0
                                        ? Row(
                                            children: [
                                              // 接受按钮
                                              GestureDetector(
                                                onTap: () => _acceptRequest(request.id),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 8.w,
                                                  ),
                                                  margin: EdgeInsets.only(right: 12.w),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFF7D45),
                                                    borderRadius: BorderRadius.circular(16.w),
                                                  ),
                                                  child: Text(
                                                    '接受',
                                                    style: TextStyle(
                                                      fontSize: 14.w,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // 拒绝按钮
                                              GestureDetector(
                                                onTap: () => _rejectRequest(request.id),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 8.w,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF0F2F5),
                                                    borderRadius: BorderRadius.circular(16.w),
                                                  ),
                                                  child: Text(
                                                    '拒绝',
                                                    style: TextStyle(
                                                      fontSize: 14.w,
                                                      color: const Color(0xFF636E72),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 6.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: request.status == 1
                                                  ? const Color(0xFFE8F5E8)
                                                  : const Color(0xFFF5E8E8),
                                              borderRadius: BorderRadius.circular(12.w),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  request.status == 1
                                                      ? Icons.check_circle
                                                      : Icons.cancel,
                                                  size: 14.w,
                                                  color: request.status == 1
                                                      ? const Color(0xFF4CAF50)
                                                      : const Color(0xFFF44336),
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  request.status == 1
                                                      ? '已添�?
                                                      : '已拒�?,
                                                  style: TextStyle(
                                                    fontSize: 12.w,
                                                    color: request.status == 1
                                                        ? const Color(0xFF4CAF50)
                                                        : const Color(0xFFF44336),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 6.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: request.status == 0
                                              ? const Color(0xFFF5F5F5)
                                              : request.status == 1
                                                  ? const Color(0xFFE8F5E8)
                                                  : const Color(0xFFF5E8E8),
                                          borderRadius: BorderRadius.circular(12.w),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              request.status == 0
                                                  ? Icons.access_time
                                                  : request.status == 1
                                                      ? Icons.check_circle
                                                      : Icons.cancel,
                                              size: 14.w,
                                              color: request.status == 0
                                                  ? const Color(0xFF9E9E9E)
                                                  : request.status == 1
                                                      ? const Color(0xFF4CAF50)
                                                      : const Color(0xFFF44336),
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              request.status == 0
                                                  ? '等待验证'
                                                  : request.status == 1
                                                      ? '已添�?
                                                      : '已拒�?,
                                              style: TextStyle(
                                                fontSize: 12.w,
                                                color: request.status == 0
                                                    ? const Color(0xFF9E9E9E)
                                                    : request.status == 1
                                                        ? const Color(0xFF4CAF50)
                                                        : const Color(0xFFF44336),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                else
                  // 空状�?
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120.w,
                          height: 120.w,
                          margin: EdgeInsets.only(bottom: 24.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F5),
                            borderRadius: BorderRadius.circular(60.w),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.person_add,
                            size: 60.w,
                            color: const Color(0xFFB2BEC3),
                          ),
                        ),
                        Text(
                          '暂无${state.activeTab == 'received' ? '收到' : '发出'}的好友申�?,
                          style: TextStyle(
                            fontSize: 16.w,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        SizedBox(height: 12.w),
                        Text(
                          state.activeTab == 'received'
                              ? '当有人申请加你为好友时，会在这里显示'
                              : '你发出的好友申请会在这里显示状�?,
                          style: TextStyle(
                            fontSize: 14.w,
                            color: const Color(0xFF636E72),
                          ),
                          textAlign: TextAlign.center,
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

