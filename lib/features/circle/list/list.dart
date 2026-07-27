import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/circle/list/bloc/bloc.dart';
import 'package:beaver/features/circle/list/bloc/event.dart';
import 'package:beaver/features/circle/list/bloc/state.dart';
import 'package:beaver/features/circle/list/data/repositories/repository.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/api/circle.dart';

class CircleListPage extends StatefulWidget {
  const CircleListPage({super.key});

  @override
  State<CircleListPage> createState() => _CircleListPageState();
}

class _CircleListPageState extends State<CircleListPage> {
  late CircleListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CircleListBloc(CircleListRepository())
      ..add(const LoadCircleListEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _showCreateDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('创建圈子'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: '圈子名称'),
              ),
              SizedBox(height: 12.w),
              TextField(
                controller: descController,
                decoration: const InputDecoration(hintText: '圈子简介（可选）'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('创建'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final name = nameController.text.trim();
    if (name.isEmpty) {
      BeaverToast.show(context, '请输入圈子名称');
      return;
    }

    _bloc.add(
      CreateCircleEvent(name: name, description: descController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<CircleListBloc, CircleListState>(
        listener: (context, state) {
          if (state.status == CircleListStatus.error &&
              state.errorMessage != null) {
            BeaverToast.show(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '我的圈子',
            isScrollable: false,
            rightSlot: GestureDetector(
              onTap: _showCreateDialog,
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7D45),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/plus-icon.svg',
                    width: 12.w,
                    height: 12.w,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            child: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(CircleListState state) {
    if (state.status == CircleListStatus.loading && state.circles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.circles.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        _bloc.add(const LoadCircleListEvent());
        await _bloc.stream.firstWhere(
          (s) => s.status != CircleListStatus.loading,
        );
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        itemCount: state.circles.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1.w, indent: 72.w, color: const Color(0xFFEBEEF5)),
        itemBuilder: (context, index) {
          return _buildCircleItem(state.circles[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/common/group.svg',
              width: 48.w,
              height: 48.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFFB2BEC3),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 16.w),
            Text(
              '还没有加入任何圈子',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 8.w),
            Text(
              '圈子仅支持邀请或分享链接加入，暂不提供搜索发现',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72)),
            ),
            SizedBox(height: 24.w),
            TextButton(
              onPressed: _showCreateDialog,
              child: Text(
                '创建圈子',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFFF7D45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleItem(ICircleListItem circle) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
      leading: BeaverAvatar(avatar: circle.avatar, size: 44),
      title: Text(
        circle.name,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2D3436),
        ),
      ),
      subtitle: Text(
        circle.description?.isNotEmpty == true
            ? circle.description!
            : '${circle.memberCount} 位成员',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72)),
      ),
      trailing: SvgPicture.asset(
        'assets/icons/common/arrow-right.svg',
        width: 16.w,
        height: 16.w,
        colorFilter: const ColorFilter.mode(Color(0xFFB2BEC3), BlendMode.srcIn),
      ),
      onTap: () {
        final uri = Uri(
          path: AppRoutes.circleFeed,
          queryParameters: {
            'circleId': circle.circleId,
            'name': circle.name,
            'memberCount': '${circle.memberCount}',
            'role': '${circle.role}',
            if (circle.avatar?.isNotEmpty == true) 'avatar': circle.avatar!,
            if (circle.description?.isNotEmpty == true)
              'desc': circle.description!,
          },
        );
        context.push(uri.toString());
      },
    );
  }
}
