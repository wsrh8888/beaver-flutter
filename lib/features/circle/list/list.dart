import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/circle/list/bloc/bloc.dart';
import 'package:beaver/features/circle/list/bloc/event.dart';
import 'package:beaver/features/circle/list/bloc/state.dart';
import 'package:beaver/features/circle/list/components/create_circle_dialog.dart';
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
  bool _showCreateDialog = false;
  bool _creating = false;

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

  void _openCreateDialog() {
    setState(() => _showCreateDialog = true);
  }

  void _closeCreateDialog() {
    if (_creating) return;
    setState(() => _showCreateDialog = false);
  }

  Future<void> _handleCreate(String name, String? avatarPath) async {
    setState(() => _creating = true);
    _bloc.add(CreateCircleEvent(name: name, avatarPath: avatarPath));

    await _bloc.stream.firstWhere(
      (s) => s.status != CircleListStatus.creating,
    );

    if (!mounted) return;

    final state = _bloc.state;
    if (state.status == CircleListStatus.error) {
      setState(() => _creating = false);
      if (state.errorMessage != null) {
        BeaverToast.show(context, state.errorMessage!);
      }
      return;
    }

    setState(() {
      _creating = false;
      _showCreateDialog = false;
    });
    BeaverToast.show(context, '圈子创建成功');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<CircleListBloc, CircleListState>(
        listener: (context, state) {
          if (!_creating &&
              state.status == CircleListStatus.error &&
              state.errorMessage != null) {
            BeaverToast.show(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '我的圈子',
            isScrollable: false,
            overlay: _showCreateDialog
                ? CreateCircleDialog(
                    submitting: _creating,
                    onCancel: _closeCreateDialog,
                    onConfirm: _handleCreate,
                  )
                : null,
            child: Stack(
              children: [
                _buildBody(state),
                _buildFab(),
              ],
            ),
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

  Widget _buildFab() {
    return Positioned(
      bottom: 20.w,
      right: 20.w,
      child: GestureDetector(
        onTap: _openCreateDialog,
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
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/friend/circle.svg',
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
          ],
        ),
      ),
    );
  }

  Widget _buildCircleItem(ICircleListItem circle) {
    final avatarSize = 44.w;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
      leading: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: BeaverAvatar(avatar: circle.avatar, size: 44),
      ),
      title: Text(
        circle.name.isNotEmpty ? circle.name : '圈子',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
      trailing: SizedBox(
        width: 16.w,
        height: 16.w,
        child: SvgPicture.asset(
          'assets/icons/common/arrow-right.svg',
          width: 16.w,
          height: 16.w,
          colorFilter:
              const ColorFilter.mode(Color(0xFFB2BEC3), BlendMode.srcIn),
        ),
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
