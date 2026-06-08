import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/group/notifications/bloc/bloc.dart';
import 'package:beaver/features/group/notifications/bloc/event.dart';
import 'package:beaver/features/group/notifications/bloc/state.dart';
import 'package:beaver/types/business/group.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/router/routes.dart';

class GroupNotificationsPage extends StatelessWidget {
  const GroupNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupNotificationsBloc()..add(const LoadGroupNotificationsEvent()),
      child: const GroupNotificationsView(),
    );
  }
}

class GroupNotificationsView extends StatelessWidget {
  const GroupNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupNotificationsBloc, GroupNotificationsState>(
      listener: (context, state) {
        if (state.status == GroupNotificationsStatus.error) {
          BeaverToast.show(context, state.errorMessage ?? '发生错误');
        }
      },
      builder: (context, state) {
        return BeaverLayout(
          title: '群通知',
          showBack: true,
          showHeader: true,
          isScrollable: false,
          child: Column(
            children: [
              Expanded(
                child: state.status == GroupNotificationsStatus.loading && state.notifications.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : state.notifications.isEmpty
                        ? _buildEmptyState()
                        : _buildNotificationList(context, state.notifications),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationList(BuildContext context, List<GroupNotification> notifications) {
    return ListView.builder(
      padding: EdgeInsets.all(12.w),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(context, notifications[index]);
      },
    );
  }

  Widget _buildNotificationItem(BuildContext context, GroupNotification notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.w,
            offset: Offset(0, 2.w),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _openGroupChat(context, notification),
              child: Row(
                children: [
          Stack(
            children: [
              BeaverCachedImage(
                fileUrl: notification.groupAvatar,
                type: CacheType.avatar,
                width: 48.w,
                height: 48.w,
                borderRadius: 12.w,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.w),
                    child: BeaverCachedImage(
                      fileUrl: notification.applicantAvatar,
                      type: CacheType.avatar,
                      width: 18.w,
                      height: 18.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.groupName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3436),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.w),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72)),
                    children: [
                      TextSpan(
                        text: notification.applicantNickname,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' 申请加入群聊'),
                    ],
                  ),
                ),
                if (notification.message?.isNotEmpty == true) ...[
                  SizedBox(height: 2.w),
                  Text(
                    '留言: ${notification.message}',
                    style: TextStyle(fontSize: 11.sp, color: const Color(0xFFB2BEC3)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 4.w),
                Text(
                  notification.createdAt,
                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFFB2BEC3)),
                ),
              ],
            ),
          ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          _buildActions(context, notification),
        ],
      ),
    );
  }

  void _openGroupChat(BuildContext context, GroupNotification notification) {
    if (notification.groupId.isEmpty) return;
    context.push('${AppRoutes.chatDetail}?id=group_${notification.groupId}');
  }

  Widget _buildActions(BuildContext context, GroupNotification notification) {
    if (notification.status == 0) {
      return Row(
        children: [
          _buildActionButton(
            text: '通过',
            isPrimary: true,
            onTap: () => context.read<GroupNotificationsBloc>().add(AcceptGroupRequestEvent(notification.id)),
          ),
          SizedBox(width: 6.w),
          _buildActionButton(
            text: '拒绝',
            isPrimary: false,
            onTap: () => context.read<GroupNotificationsBloc>().add(RejectGroupRequestEvent(notification.id)),
          ),
        ],
      );
    } else {
      return _buildStatusBadge(notification.status);
    }
  }

  Widget _buildActionButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(colors: [Color(0xFFFF7D45), Color(0xFFE86835)])
              : null,
          color: isPrimary ? null : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12.w),
          border: isPrimary ? null : Border.all(color: const Color(0xFFEBEEF5)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : const Color(0xFF636E72),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int status) {
    String text;
    Color color;
    Color bgColor;

    if (status == 1) {
      text = '已通过';
      color = const Color(0xFFFF7D45);
      bgColor = const Color(0xFFFF7D45).withValues(alpha: 0.1);
    } else {
      text = '已拒绝';
      color = const Color(0xFFFF5252);
      bgColor = const Color(0xFFFF5252).withValues(alpha: 0.1);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 60.w,
              color: const Color(0xFFB2BEC3),
            ),
          ),
          SizedBox(height: 32.w),
          Text(
            '暂无群通知',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }
}
