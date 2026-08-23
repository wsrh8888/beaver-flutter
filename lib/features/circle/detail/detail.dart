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
import 'package:beaver/features/circle/detail/bloc/bloc.dart';
import 'package:beaver/features/circle/detail/bloc/event.dart';
import 'package:beaver/features/circle/detail/bloc/state.dart';
import 'package:beaver/features/circle/detail/components/comment_section.dart';
import 'package:beaver/features/moment/detail/components/bottom_input.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/types/cache.dart';

class CircleDetailPage extends StatelessWidget {
  final String postId;
  final String? replyCommentId;

  const CircleDetailPage({
    super.key,
    required this.postId,
    this.replyCommentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CircleDetailBloc()..add(LoadCircleDetailEvent(postId)),
      child: CircleDetailView(
        postId: postId,
        replyCommentId: replyCommentId,
      ),
    );
  }
}

class CircleDetailView extends StatefulWidget {
  final String postId;
  final String? replyCommentId;

  const CircleDetailView({
    super.key,
    required this.postId,
    this.replyCommentId,
  });

  @override
  State<CircleDetailView> createState() => _CircleDetailViewState();
}

class _CircleDetailViewState extends State<CircleDetailView> {
  final ScrollController _scrollController = ScrollController();
  int _openInputKey = 0;

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
        _scrollController.position.maxScrollExtent - 120) {
      context.read<CircleDetailBloc>().add(const LoadMoreCircleCommentsEvent());
    }
  }

  String _formatTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes == 0 ? 1 : diff.inMinutes}分钟前';
      }
      if (diff.inHours < 24) return '${diff.inHours}小时前';
      if (diff.inDays < 30) return '${diff.inDays}天前';
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  String _replyPlaceholder(CircleDetailState state) {
    final target = state.replyTarget;
    if (target == null) return '说点什么...';
    final info = context.read<ContactStore>().getContact(target.userId);
    final name = info?.nickname.isNotEmpty == true
        ? info!.nickname
        : target.userName;
    return '回复 $name';
  }

  void _openReplyInput(ICircleCommentItem comment) {
    context.read<CircleDetailBloc>().add(SetCircleReplyTargetEvent(comment));
    setState(() => _openInputKey++);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CircleDetailBloc, CircleDetailState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != prev.errorMessage ||
          (prev.replyTarget == null && curr.replyTarget != null),
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          BeaverToast.show(context, state.errorMessage!);
        }
        if (state.replyTarget != null) {
          setState(() => _openInputKey++);
        }
      },
      builder: (context, state) {
        final post = state.post;

        return BeaverLayout(
          title: '帖子详情',
          isScrollable: false,
          child: state.status == CircleDetailStatus.error && post == null
              ? Center(
                  child: Text(
                    state.errorMessage ?? '加载失败',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                )
              : Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            color: const Color(0xFFFF7D45),
                            onRefresh: () async {
                              context.read<CircleDetailBloc>().add(
                                    const RefreshCircleDetailEvent(),
                                  );
                            },
                            child: ListView(
                              controller: _scrollController,
                              padding: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 12.w),
                              children: [
                                if (post != null) ...[
                                  _buildPostContent(post),
                                  Padding(
                                    padding: EdgeInsets.only(top: 12.w, bottom: 4.w),
                                    child: Text(
                                      '评论 ${post.commentCount}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                  ),
                                  CircleCommentSection(
                                    comments: post.comments,
                                    onReply: _openReplyInput,
                                    onLoadMoreChildren: (root) {
                                      context.read<CircleDetailBloc>().add(
                                            LoadChildCircleCommentsEvent(root),
                                          );
                                    },
                                  ),
                                  if (state.isLoadingComments)
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16.w),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        if (post != null && state.replyTarget != null)
                          _buildReplyBanner(state),
                        if (post != null)
                          MomentBottomInput(
                            isLiked: post.isLiked,
                            replyPlaceholder: _replyPlaceholder(state),
                            openInputKey: _openInputKey,
                            onQuickLike: () {
                              context.read<CircleDetailBloc>().add(
                                    const ToggleCircleDetailLikeEvent(),
                                  );
                            },
                            onSendComment: (content) {
                              context.read<CircleDetailBloc>().add(
                                    AddCircleCommentEvent(
                                      content: content,
                                      targetComment: state.replyTarget,
                                    ),
                                  );
                            },
                            onCloseReply: () {
                              context.read<CircleDetailBloc>().add(
                                    const SetCircleReplyTargetEvent(null),
                                  );
                            },
                          ),
                      ],
                    ),
        );
      },
    );
  }

  Widget _buildReplyBanner(CircleDetailState state) {
    final target = state.replyTarget!;
    final name = context.read<ContactStore>().getContact(target.userId);
    final display = name?.nickname.isNotEmpty == true
        ? name!.nickname
        : target.userName;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      color: const Color(0xFFF8F9FA),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '回复 $display',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72)),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<CircleDetailBloc>().add(
                    const SetCircleReplyTargetEvent(null),
                  );
            },
            child: Icon(Icons.close, size: 18.w, color: const Color(0xFFB2BEC3)),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(IGetPostDetailRes post) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: const Color(0xFFEBEEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.w),
                child: BeaverCachedImage(
                  fileUrl: post.avatar,
                  type: CacheType.avatar,
                  width: 36.w,
                  height: 36.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.userName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    Text(
                      _formatTime(post.createdAt),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFFB2BEC3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (post.title.isNotEmpty) ...[
            SizedBox(height: 12.w),
            Text(
              post.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
          ],
          if (post.content.isNotEmpty) ...[
            SizedBox(height: 8.w),
            Text(
              post.content,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.5,
                color: const Color(0xFF2D3436),
              ),
            ),
          ],
          if (post.files.isNotEmpty) ...[
            SizedBox(height: 10.w),
            _buildImagesGrid(post.files),
          ],
          SizedBox(height: 10.w),
          Row(
            children: [
              Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 14.w,
                color: post.isLiked
                    ? const Color(0xFFFF4757)
                    : const Color(0xFF636E72),
              ),
              SizedBox(width: 4.w),
              Text(
                '${post.likeCount}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
              SizedBox(width: 16.w),
              Icon(Icons.chat_bubble_outline, size: 14.w, color: const Color(0xFF636E72)),
              SizedBox(width: 4.w),
              Text(
                '${post.commentCount}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagesGrid(List<ICirclePostFile> files) {
    final images = files.where((f) => f.type == 2).toList();
    if (images.isEmpty) return const SizedBox.shrink();
    final display = images.length > 9 ? images.sublist(0, 9) : images;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = images.length == 1
            ? 1
            : (images.length == 2 || images.length == 4 ? 2 : 3);
        final spacing = 2.w;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: display.map((file) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: SizedBox(
                width: images.length == 1
                    ? constraints.maxWidth * 0.7
                    : itemWidth,
                height: images.length == 1
                    ? constraints.maxWidth * 0.7
                    : itemWidth,
                child: BeaverCachedImage(
                  fileUrl: file.fileKey,
                  type: CacheType.image,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
