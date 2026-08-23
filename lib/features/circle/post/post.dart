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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/circle/post/bloc/bloc.dart';
import 'package:beaver/features/circle/post/bloc/event.dart';
import 'package:beaver/features/circle/post/bloc/state.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/utils/media_util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CirclePostPage extends StatelessWidget {
  final String circleId;

  const CirclePostPage({super.key, required this.circleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CirclePostBloc(circleId: circleId),
      child: const CirclePostView(),
    );
  }
}

class CirclePostView extends StatefulWidget {
  const CirclePostView({super.key});

  @override
  State<CirclePostView> createState() => _CirclePostViewState();
}

class _CirclePostViewState extends State<CirclePostView> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    context.read<CirclePostBloc>().add(const SubmitCirclePostEvent());
  }

  Future<void> _chooseImage() async {
    final bloc = context.read<CirclePostBloc>();
    final remaining = 9 - bloc.state.mediaList.length;
    if (remaining <= 0) return;

    final assets = await pickAssets(context, type: RequestType.image);
    if (assets == null || assets.isEmpty) return;

    for (final asset in assets.take(remaining)) {
      final file = await asset.file;
      if (file != null) {
        bloc.add(AddCirclePostImageEvent(file.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CirclePostBloc, CirclePostState>(
      listener: (context, state) {
        if (state.status == CirclePostStatus.error &&
            state.errorMessage != null) {
          BeaverToast.show(context, state.errorMessage!);
        } else if (state.errorMessage != null &&
            state.status != CirclePostStatus.error) {
          BeaverToast.show(context, state.errorMessage!);
        } else if (state.status == CirclePostStatus.success) {
          BeaverToast.show(context, '发布成功');
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return BeaverLayout(
          title: '发布帖子',
          isScrollable: true,
          rightSlot: GestureDetector(
            onTap: state.canPost && state.status != CirclePostStatus.loading
                ? _handleSubmit
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
              decoration: BoxDecoration(
                color: state.canPost
                    ? const Color(0xFFFF7D45)
                    : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: state.status == CirclePostStatus.loading
                  ? SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '发布',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: state.canPost
                            ? Colors.white
                            : const Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _contentController,
                  onChanged: (value) {
                    context
                        .read<CirclePostBloc>()
                        .add(UpdateCirclePostContentEvent(value));
                  },
                  maxLines: 10,
                  minLines: 5,
                  maxLength: 2000,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '分享此刻的想法...',
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFFB2BEC3),
                    ),
                    counterText: '',
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF2D3436),
                    height: 1.5,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${state.content.length}/2000',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFFB2BEC3),
                    ),
                  ),
                ),
                SizedBox(height: 24.w),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.w,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.mediaList.length +
                      (state.mediaList.length < 9 ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.mediaList.length) {
                      return _buildMediaItem(state.mediaList[index], index);
                    }
                    return _buildAddMediaItem();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaItem(String imageUrl, int index) {
    final isLocal = !imageUrl.startsWith('http');
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            image: DecorationImage(
              image: isLocal
                  ? FileImage(File(imageUrl)) as ImageProvider
                  : NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4.w,
          right: 4.w,
          child: GestureDetector(
            onTap: () {
              context
                  .read<CirclePostBloc>()
                  .add(RemoveCirclePostImageEvent(index));
            },
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12.w),
              ),
              alignment: Alignment.center,
              child: Text(
                '×',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddMediaItem() {
    return GestureDetector(
      onTap: _chooseImage,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.w),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.add, size: 40.w, color: const Color(0xFFB2BEC3)),
      ),
    );
  }
}
