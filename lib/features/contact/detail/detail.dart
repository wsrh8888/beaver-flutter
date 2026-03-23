import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/features/contact/detail/bloc/bloc.dart';
import 'package:beaver/features/contact/detail/bloc/event.dart';
import 'package:beaver/features/contact/detail/bloc/state.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/button/button.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class ContactDetailPage extends StatelessWidget {
  final String? userId;
  const ContactDetailPage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ContactDetailBloc();
        if (userId != null) {
          bloc.add(LoadUserInfoEvent(userId!));
        }
        return bloc;
      },
      child: const ContactDetailView(),
    );
  }
}

class ContactDetailView extends StatefulWidget {
  const ContactDetailView({super.key});

  @override
  State<ContactDetailView> createState() => _ContactDetailViewState();
}

class _ContactDetailViewState extends State<ContactDetailView> {
  final TextEditingController _remarkController = TextEditingController();

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactDetailBloc, DetailState>(
      listener: (context, state) {
        if (state.status == DetailStatus.error) {
          BeaverToast.show(context, state.errorMessage ?? '发生错误');
        }
        if (state.showEditNoteDialog) {
          _remarkController.text = state.newRemarkName ?? '';
          _showEditRemarkDialog(context);
        }
        if (state.navigateToChat && state.conversationIdForChat != null) {
          context.push(
            '${AppRoutes.chatDetail}?id=${state.conversationIdForChat}',
          );
          context.read<ContactDetailBloc>().add(const ClearNavigationEvent());
        }
      },
      builder: (context, state) {
        final userInfo = state.userInfo;
        final isFriend = state.isFriend;

        return BeaverLayout(
          title: isFriend ? '好友资料' : '用户资料',
          showBack: true,
          showHeader: true,
          showBackground: true,
          backgroundHeight: 90.w, // 180rpx / 2
          rightSlot: isFriend
              ? GestureDetector(
                  onTap: () => context.read<ContactDetailBloc>().add(
                    const ToggleMoreMenuEvent(),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: Offset(0, 1.w),
                          blurRadius: 4.w,
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/detail/more-icon.svg',
                      width: 16.w, // 32rpx / 2
                      height: 16.w,
                    ),
                  ),
                )
              : null,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12.w), // 24rpx / 2
                child: Column(
                  children: [
                    SizedBox(height: 10.w),
                    if (userInfo != null) ...[
                      _buildUserInfoCard(state),
                      SizedBox(height: 12.w),
                      // 这里可以添加 PhotoCard
                    ] else if (state.status == DetailStatus.loading)
                      const Center(child: CircularProgressIndicator())
                    else
                      const Center(child: Text('用户不存在')),
                    SizedBox(height: 84.w), // 为底部操作栏留出空间 (168rpx / 2)
                  ],
                ),
              ),
              if (userInfo != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildActionBar(state),
                ),
              if (state.showMoreMenu) _buildMoreMenu(context),
              if (state.showMoreMenu)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => context.read<ContactDetailBloc>().add(
                      const ToggleMoreMenuEvent(),
                    ),
                    child: Container(color: Colors.transparent),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserInfoCard(DetailState state) {
    final userInfo = state.userInfo!;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 20.w), // 32rpx, 40rpx
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w), // 24rpx
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: Offset(0, 2.w),
            blurRadius: 12.w,
          ),
        ],
      ),
      child: Column(
        children: [
          // 用户头像和基本信息
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70.w, // 140rpx
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      offset: Offset(0, 3.w),
                      blurRadius: 10.w,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BeaverCachedImage(
                    fileKey: userInfo.fileName,
                    type: CacheType.avatar,
                    width: 70.w,
                    height: 70.w,
                  ),
                ),
              ),
              SizedBox(height: 12.w),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userInfo.remarkName?.isNotEmpty == true
                            ? userInfo.remarkName!
                            : userInfo.nickname,
                        style: TextStyle(
                          fontSize: 20.sp, // 40rpx
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                      if (userInfo.gender == 'male') ...[
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          'assets/icons/detail/gender-male-icon.svg',
                          width: 18.w, // 36rpx
                          height: 18.w,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.w),
                  Text(
                    'ID: ${userInfo.userId}',
                    style: TextStyle(
                      fontSize: 12.sp, // 24rpx
                      color: const Color(0xFFB2BEC3),
                      fontFamily: 'monospace',
                    ),
                  ),
                  SizedBox(height: 8.w),
                  Container(
                    constraints: BoxConstraints(maxWidth: 240.w), // 480rpx
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Text(
                      userInfo.signature?.isNotEmpty == true
                          ? userInfo.signature!
                          : '这个人很懒，什么都没写~',
                      style: TextStyle(
                        fontSize: 14.sp, // 28rpx
                        color: const Color(0xFF636E72),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.w),
          Container(height: 0.5.w, color: const Color(0xFFF0F3F4)),
          SizedBox(height: 20.w),
          // 信息列表
          _buildInfoList(state),
        ],
      ),
    );
  }

  Widget _buildInfoList(DetailState state) {
    final userInfo = state.userInfo!;
    final List<Map<String, String>> items = [];

    if (state.isFriend) {
      if (userInfo.remarkName?.isNotEmpty == true) {
        items.add({'label': '备注', 'value': userInfo.remarkName!});
      }
      if (userInfo.source != null) {
        items.add({'label': '来源', 'value': _getSourceText(userInfo.source!)});
      }
    }

    if (userInfo.nickname.isNotEmpty) {
      items.add({'label': '昵称', 'value': userInfo.nickname});
    }

    items.add({
      'label': '性别',
      'value': userInfo.gender == 'male'
          ? '男'
          : userInfo.gender == 'female'
          ? '女'
          : '未设置',
    });

    return Column(
      children: items.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 6.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF8F9FA), Color(0xFFF0F3F4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['label']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF636E72),
                ),
              ),
              Expanded(
                child: Text(
                  item['value']!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionBar(DetailState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.w, 20.w, 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(0, -2.w),
            blurRadius: 10.w,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: BeaverButton(
              text: '发消息',
              onPressed: () => context.read<ContactDetailBloc>().add(
                const SendMessageEvent(),
              ),
              height: 44.w,
            ),
          ),
          SizedBox(width: 12.w),
          _buildActionIconButton(
            icon: 'assets/icons/detail/voice-call-icon.svg',
            onTap: () =>
                context.read<ContactDetailBloc>().add(const AudioCallEvent()),
          ),
          SizedBox(width: 12.w),
          _buildActionIconButton(
            icon: 'assets/icons/detail/video-call-icon.svg',
            onTap: () =>
                context.read<ContactDetailBloc>().add(const VideoCallEvent()),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIconButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F7),
          borderRadius: BorderRadius.circular(12.w),
        ),
        padding: EdgeInsets.all(10.w),
        child: SvgPicture.asset(
          icon,
          colorFilter: const ColorFilter.mode(
            Color(0xFF636E72),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildMoreMenu(BuildContext context) {
    return Positioned(
      top: 50.w,
      right: 12.w,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 140.w, // 280rpx
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: Offset(0, 4.w),
                blurRadius: 12.w,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem(
                icon: 'assets/icons/detail/edit-note-icon.svg',
                text: '编辑备注',
                onTap: () {
                  context.read<ContactDetailBloc>().add(
                    const ToggleMoreMenuEvent(),
                  );
                  context.read<ContactDetailBloc>().add(
                    const ShowEditNoteDialogEvent(),
                  );
                },
              ),
              Container(
                height: 0.5.w,
                color: const Color(0xFFF0F3F4),
                margin: EdgeInsets.symmetric(horizontal: 12.w),
              ),
              _buildMenuItem(
                icon: 'assets/icons/detail/delete-icon.svg',
                text: '删除好友',
                textColor: const Color(0xFFFF4D4F),
                onTap: () {
                  context.read<ContactDetailBloc>().add(
                    const ToggleMoreMenuEvent(),
                  );
                  _showDeleteConfirmDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
        color: Colors.transparent,
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 18.w, height: 18.w),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: textColor ?? const Color(0xFF2D3436),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSourceText(String source) {
    const sourceMap = {
      'search': '搜索',
      'qrcode': '二维码',
      'group': '群聊',
      'card': '名片',
      'link': '链接',
      'other': '其他',
    };
    return sourceMap[source] ?? source;
  }

  void _showEditRemarkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑备注'),
        content: TextField(
          controller: _remarkController,
          decoration: const InputDecoration(hintText: '请输入备注名称'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ContactDetailBloc>().add(
                const CloseEditNoteDialogEvent(),
              );
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              context.read<ContactDetailBloc>().add(
                SaveRemarkNameEvent(_remarkController.text),
              );
              context.read<ContactDetailBloc>().add(
                const CloseEditNoteDialogEvent(),
              );
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除好友'),
        content: const Text('确定要删除该好友吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              context.read<ContactDetailBloc>().add(const DeleteFriendEvent());
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
