import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/circle/feed/bloc/bloc.dart';
import 'package:beaver/features/circle/feed/bloc/event.dart';
import 'package:beaver/features/circle/feed/bloc/state.dart';
import 'package:beaver/features/circle/feed/components/post_item.dart';
import 'package:beaver/features/circle/invite/invite_sheet.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class CircleFeedPage extends StatelessWidget {
  final String circleId;
  final String circleName;
  final int memberCount;
  final int role;
  final String? avatar;
  final String? desc;

  const CircleFeedPage({
    super.key,
    required this.circleId,
    required this.circleName,
    this.memberCount = 0,
    this.role = 0,
    this.avatar,
    this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CircleFeedBloc(circleId: circleId)
        ..add(const LoadCircleFeedEvent(refresh: true)),
      child: CircleFeedView(
        circleId: circleId,
        circleName: circleName,
        memberCount: memberCount,
        role: role,
        avatar: avatar,
        desc: desc,
      ),
    );
  }
}

class CircleFeedView extends StatefulWidget {
  final String circleId;
  final String circleName;
  final int memberCount;
  final int role;
  final String? avatar;
  final String? desc;

  const CircleFeedView({
    super.key,
    required this.circleId,
    required this.circleName,
    required this.memberCount,
    required this.role,
    this.avatar,
    this.desc,
  });

  @override
  State<CircleFeedView> createState() => _CircleFeedViewState();
}

class _CircleFeedViewState extends State<CircleFeedView> {
  final ScrollController _scrollController = ScrollController();

  bool get _canPost => widget.role > 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<CircleFeedBloc>();
      if (bloc.state.status == CircleFeedStatus.success && bloc.state.hasMore) {
        bloc.add(const LoadCircleFeedEvent());
      }
    }
  }

  Future<void> _openPostPage() async {
    final uri = Uri(
      path: AppRoutes.circlePost,
      queryParameters: {'circleId': widget.circleId},
    );
    final result = await context.push(uri.toString());
    if (result == true && mounted) {
      context.read<CircleFeedBloc>().add(
            const LoadCircleFeedEvent(refresh: true),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CircleFeedBloc, CircleFeedState>(
      listener: (context, state) {
        if (state.status == CircleFeedStatus.error &&
            state.errorMessage != null &&
            state.posts.isNotEmpty) {
          BeaverToast.show(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return BeaverLayout(
          title: widget.circleName.isNotEmpty ? widget.circleName : '圈子',
          isScrollable: false,
          rightSlot: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_canPost)
                GestureDetector(
                  onTap: () => showCircleInviteSheet(
                    context: context,
                    circleId: widget.circleId,
                    circleName: widget.circleName,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Icon(
                      Icons.ios_share,
                      size: 20.w,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                ),
              if (_canPost)
                GestureDetector(
                  onTap: _openPostPage,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7D45),
                      borderRadius: BorderRadius.circular(14.w),
                    ),
                    child: Text(
                      '发帖',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          child: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(CircleFeedState state) {
    if (state.status == CircleFeedStatus.loading && state.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == CircleFeedStatus.error && state.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage ?? '加载失败',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF636E72)),
            ),
            SizedBox(height: 12.w),
            TextButton(
              onPressed: () => context.read<CircleFeedBloc>().add(
                    const LoadCircleFeedEvent(refresh: true),
                  ),
              child: Text(
                '点击重试',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFFF7D45),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFFF7D45),
      onRefresh: () async {
        context.read<CircleFeedBloc>().add(
              const LoadCircleFeedEvent(refresh: true),
            );
        await context.read<CircleFeedBloc>().stream.firstWhere(
              (s) => s.status != CircleFeedStatus.loading,
            );
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 24.w),
        itemCount: state.posts.length + 1 + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader(state);
          }

          final dataIndex = index - 1;
          if (dataIndex >= state.posts.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.w),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final post = state.posts[dataIndex];
          return CirclePostItem(
            post: post,
            onLike: () => context.read<CircleFeedBloc>().add(
                  ToggleLikeCirclePostEvent(post.postId),
                ),
            onTap: () async {
              final uri = Uri(
                path: AppRoutes.circleDetail,
                queryParameters: {'postId': post.postId},
              );
              await context.push(uri.toString());
              if (mounted) {
                context.read<CircleFeedBloc>().add(
                      const LoadCircleFeedEvent(refresh: true),
                    );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(CircleFeedState state) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.memberCount} 成员 · ${state.posts.length} 帖子',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF636E72),
            ),
          ),
          if (state.posts.isEmpty) ...[
            SizedBox(height: 48.w),
            Center(
              child: Text(
                _canPost ? '还没有帖子，来发第一条吧' : '还没有帖子',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
