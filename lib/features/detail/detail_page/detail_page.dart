import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/detail/detail_page/bloc/bloc.dart';
import 'package:beaver/features/detail/detail_page/bloc/event.dart';
import 'package:beaver/features/detail/detail_page/bloc/state.dart';
import 'package:beaver/features/detail/detail_page/data/repositories/repository.dart';
import 'package:beaver/features/detail/detail_page/data/models/user_info.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/dialog/dialog.dart';

class DetailPage extends StatefulWidget {
  final String userId;

  const DetailPage({super.key, required this.userId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DetailBloc _detailBloc;
  final TextEditingController _remarkNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detailBloc = DetailBloc(DetailRepository())..add(LoadUserInfoEvent(widget.userId));
  }

  @override
  void dispose() {
    _detailBloc.close();
    _remarkNameController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _toggleMoreMenu() {
    _detailBloc.add(ToggleMoreMenuEvent());
  }

  void _showEditNote() {
    _detailBloc.add(ShowEditNoteDialogEvent());
  }

  void _closeEditNote() {
    _detailBloc.add(CloseEditNoteDialogEvent());
  }

  void _saveRemarkName() {
    _detailBloc.add(SaveRemarkNameEvent(_remarkNameController.text));
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除好友'),
        content: const Text('确定要删除此好友吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _detailBloc.add(DeleteFriendEvent());
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    _detailBloc.add(SendMessageEvent());
  }

  void _audioCall() {
    _detailBloc.add(AudioCallEvent());
  }

  void _videoCall() {
    _detailBloc.add(VideoCallEvent());
  }

  void _viewAllPhotos() {
    // 查看所有照片
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _detailBloc,
      child: BlocConsumer<DetailBloc, DetailState>(
        listener: (context, state) {
          if (state.status == DetailStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          } else if (state.status == DetailStatus.success && state.userInfo != null) {
            if (state.showEditNoteDialog) {
              _remarkNameController.text = state.newRemarkName ?? '';
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('编辑备注'),
                  content: TextField(
                    controller: _remarkNameController,
                    decoration: const InputDecoration(
                      hintText: '请输入备注名称',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: _closeEditNote,
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: _saveRemarkName,
                      child: const Text('保存'),
                    ),
                  ],
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final userInfo = state.userInfo;
          final pageTitle = state.isFriend ? '好友资料' : '用户资料';

          return Stack(
            children: [
              BeaverLayout(
                title: pageTitle,
                showBack: true,
                showBackground: true,
                isScrollable: true,
                afterHeight: 168.w,
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      // 用户信息卡片
                      Container(
                        padding: EdgeInsets.all(24.w),
                        margin: EdgeInsets.only(top: 80.w, bottom: 24.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.w),
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
                            // 用户基本信息
                            Container(
                              margin: EdgeInsets.only(bottom: 24.w),
                              child: Row(
                                children: [
                                  // 头像
                                  Container(
                                    margin: EdgeInsets.only(right: 20.w),
                                    child: BeaverAvatar(
                                      url: userInfo?.fileName ?? '',
                                      size: 80.w,
                                    ),
                                  ),
                                  // 信息
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              userInfo?.remarkName ?? userInfo?.nickname ?? '未知用户',
                                              style: TextStyle(
                                                fontSize: 18.w,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3436),
                                              ),
                                            ),
                                            if (userInfo?.gender == 'male')
                                              Container(
                                                margin: EdgeInsets.only(left: 8.w),
                                                child: Icon(
                                                  Icons.male,
                                                  size: 20.w,
                                                  color: Colors.blue,
                                                ),
                                              ),                                         ],
                                        ),
                                        SizedBox(height: 8.w),
                                        Text(
                                          'ID: ${userInfo?.userId ?? ''}',
                                          style: TextStyle(
                                            fontSize: 14.w,
                                            color: const Color(0xFFB2BEC3),
                                          ),
                                        ),
                                        SizedBox(height: 8.w),
                                        Text(
                                          userInfo?.signature ?? '这个人很懒，什么都没写~',
                                          style: TextStyle(
                                            fontSize: 14.w,
                                            color: const Color(0xFF636E72),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 信息列表
                            Container(
                              child: Column(
                                children: [
                                  // 好友信息（仅好友显示）
                                  if (state.isFriend && userInfo != null) ...[
                                    if (userInfo.remarkName != null && userInfo.remarkName!.isNotEmpty)
                                      _buildInfoItem('备注', userInfo.remarkName!),
                                  ],
                                  // 基本资料
                                  if (userInfo != null) ...[
                                    _buildInfoItem('昵称', userInfo.nickname),
                                    _buildInfoItem('性别', userInfo.gender == 'male' ? '男' : userInfo.gender == 'female' ? '女' : '未设置'),
                                    if (userInfo.location != null && userInfo.location!.isNotEmpty)
                                      _buildInfoItem('地区', userInfo.location!),
                                    if (userInfo.age != null && userInfo.age!.isNotEmpty)
                                      _buildInfoItem('年龄', userInfo.age!),
                                    if (userInfo.constellation != null && userInfo.constellation!.isNotEmpty)
                                      _buildInfoItem('星座', userInfo.constellation!),
                                    if (userInfo.occupation != null && userInfo.occupation!.isNotEmpty)
                                      _buildInfoItem('职业', userInfo.occupation!),
                                    if (userInfo.education != null && userInfo.education!.isNotEmpty)
                                      _buildInfoItem('学历', userInfo.education!),
                                    if (userInfo.hobbies != null && userInfo.hobbies!.isNotEmpty)
                                      _buildInfoItem('爱好', userInfo.hobbies!),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 相册预览卡片
                      if (userInfo != null && userInfo.photos.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.w),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '相册',
                                      style: TextStyle(
                                        fontSize: 16.w,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _viewAllPhotos,
                                      child: Text(
                                        '查看全部',
                                        style: TextStyle(
                                          fontSize: 14.w,
                                          color: const Color(0xFFFF7D45),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 照片网格
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12.w,
                                    mainAxisSpacing: 12.w,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: userInfo.photos.length > 6 ? 6 : userInfo.photos.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.w),
                                        image: DecorationImage(
                                          image: NetworkImage(userInfo.photos[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                after: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, -4.w),
                        blurRadius: 12.w,
                      ),
                    ],
                  ),
                  child: state.isFriend
                      ? Row(
                          children: [
                            // 消息按钮
                            Expanded(
                              child: GestureDetector(
                                onTap: _sendMessage,
                                child: Container(
                                  height: 48.w,
                                  margin: EdgeInsets.only(right: 12.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F2F5),
                                    borderRadius: BorderRadius.circular(24.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '发消息',
                                    style: TextStyle(
                                      fontSize: 16.w,
                                      color: const Color(0xFF2D3436),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // 语音通话
                            GestureDetector(
                              onTap: _audioCall,
                              child: Container(
                                width: 48.w,
                                height: 48.w,
                                margin: EdgeInsets.only(right: 12.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE6D9),
                                  borderRadius: BorderRadius.circular(24.w),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.phone,
                                  size: 24.w,
                                  color: const Color(0xFFFF7D45),
                                ),
                              ),
                            ),
                            // 视频通话
                            GestureDetector(
                              onTap: _videoCall,
                              child: Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE6D9),
                                  borderRadius: BorderRadius.circular(24.w),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.video_call,
                                  size: 24.w,
                                  color: const Color(0xFFFF7D45),
                                ),
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7D45),
                              borderRadius: BorderRadius.circular(24.w),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '添加好友',
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
              // 更多菜单
              if (state.showMoreMenu && state.isFriend)
                Stack(
                  children: [
                    // 遮罩层
                    GestureDetector(
                      onTap: _toggleMoreMenu,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    // 菜单
                    Positioned(
                      top: 88.w,
                      right: 20.w,
                      child: Container(
                        width: 160.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 4.w),
                              blurRadius: 12.w,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // 编辑备注
                            GestureDetector(
                              onTap: () {
                                _toggleMoreMenu();
                                _showEditNote();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 20.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 20.w,
                                      color: const Color(0xFF2D3436),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '编辑备注',
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // 分割线
                            Container(
                              height: 1.w,
                              color: const Color(0xFFEBEEF5),
                            ),
                            // 删除好友
                            GestureDetector(
                              onTap: () {
                                _toggleMoreMenu();
                                _confirmDelete();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 20.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 20.w,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '删除好友',
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w),
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
            label,
            style: TextStyle(
              fontSize: 14.w,
              color: const Color(0xFF636E72),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.w,
              color: const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }
}
