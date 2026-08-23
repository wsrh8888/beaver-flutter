/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/circle/feed/bloc/bloc.dart';
import 'package:beaver/features/circle/feed/bloc/event.dart';
import 'package:beaver/features/circle/feed/bloc/state.dart';
import 'package:beaver/features/circle/feed/components/post_item.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/badge/circle_badge.dart';
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

  void _openSetting() {
    final uri = Uri(
      path: AppRoutes.circleSetting,
      queryParameters: {'circleId': widget.circleId},
    );
    context.push(uri.toString());
  }

  Widget _buildMoreButton() {
    return GestureDetector(
      onTap: _openSetting,
      child: Container(
        width: 36.w,
        height: 36.w,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/images/chat/more.svg',
          width: 22.w,
          height: 22.w,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final name =
        widget.circleName.isNotEmpty ? widget.circleName : '圈子';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 6.w),
        const CircleBadge(),
      ],
    );
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
          titleWidget: _buildTitle(),
          isScrollable: false,
          rightSlot: _buildMoreButton(),
          child: Stack(
            children: [
              _buildBody(state),
              if (_canPost)
                Positioned(
                  right: 16.w,
                  bottom: 24.w,
                  child: FloatingActionButton(
                    backgroundColor: const Color(0xFFFF7D45),
                    onPressed: _openPostPage,
                    child: Icon(Icons.edit, color: Colors.white, size: 22.w),
                  ),
                ),
            ],
          ),
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
        padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, _canPost ? 88.w : 24.w),
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
    if (state.posts.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.w),
        child: Center(
          child: Text(
            _canPost ? '还没有帖子，来发第一条吧' : '还没有帖子',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF636E72),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
