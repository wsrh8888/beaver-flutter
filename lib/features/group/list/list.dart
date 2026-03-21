import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beaver/features/group/list/bloc/bloc.dart';
import 'package:beaver/features/group/list/bloc/event.dart';
import 'package:beaver/features/group/list/bloc/state.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/router/routes.dart';
import 'package:go_router/go_router.dart';

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
    _groupListBloc = GroupListBloc()..add(LoadGroupListEvent());
  }

  @override
  void dispose() {
    _groupListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _groupListBloc,
      child: BlocBuilder<GroupListBloc, GroupListState>(
        builder: (context, state) {
          return BeaverLayout(
            title: '我的群聊',
            showBack: true,
            showHeader: true,
            child: Stack(
              children: [_buildGroupList(state), _buildFab(context)],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupList(GroupListState state) {
    if (state.status == GroupListStatus.loading && state.groupList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.groupList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: state.groupList.length,
      itemBuilder: (context, index) {
        final group = state.groupList[index];
        return _buildGroupItem(context, group);
      },
    );
  }

  Widget _buildGroupItem(BuildContext context, dynamic group) {
    return GestureDetector(
      onTap: () => context.push(
        '${AppRoutes.chatDetail}?id=${group.conversationId}&type=group',
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: Offset(0, 2.w),
              blurRadius: 8.w,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildGroupAvatar(group.fileName),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3436),
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.w),
                  Text(
                    group.lastMessage.isNotEmpty ? group.lastMessage : '暂无消息',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF636E72),
                      height: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.w),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/group/member.svg',
                        width: 14.w,
                        height: 14.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFB2BEC3),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${group.memberCount}人',
                        style: TextStyle(
                          fontSize: 12.sp,
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
    );
  }

  Widget _buildGroupAvatar(String fileKey) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7D45).withValues(alpha: 0.2),
            offset: Offset(0, 4.w),
            blurRadius: 12.w,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.w),
        child: BeaverCachedImage(
          fileKey: fileKey,
          type: CacheType.avatar,
          width: 48.w,
          height: 48.w,
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Positioned(
      bottom: 24.w,
      right: 20.w,
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.groupCreate),
        child: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE86835), Color(0xFFD55A2B)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE86835).withValues(alpha: 0.4),
                offset: Offset(0, 4.w),
                blurRadius: 12.w,
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/group/add.svg',
              width: 20.w,
              height: 20.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/group.svg',
            width: 80.w,
            height: 80.w,
            colorFilter: const ColorFilter.mode(
              Color(0xFFB2BEC3),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 16.w),
          Text(
            '暂无群聊',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF636E72)),
          ),
        ],
      ),
    );
  }
}
