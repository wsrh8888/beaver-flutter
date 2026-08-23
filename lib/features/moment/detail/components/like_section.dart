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
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/api/moment.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/store/contact/contact.dart';

class MomentLikeSection extends StatelessWidget {
  final List<IMomentLikeModel> likes;

  const MomentLikeSection({super.key, required this.likes});

  @override
  Widget build(BuildContext context) {
    if (likes.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.w),
        child: Center(
          child: Text(
            '暂无点赞',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
          ),
        ),
      );
    }

    final contactStore = context.read<ContactStore>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.w),
      child: Wrap(
        spacing: 16.w,
        runSpacing: 16.w,
        children: likes.map((like) {
          final info = contactStore.getContact(like.userId);
          final name = info?.nickname.isNotEmpty == true
              ? info!.nickname
              : like.userName;
          final avatar = info?.avatar ?? like.avatar;

          return SizedBox(
            width: 60.w,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.w),
                  child: SizedBox(
                    width: 50.w,
                    height: 50.w,
                    child: BeaverCachedImage(
                      fileUrl: avatar,
                      type: CacheType.avatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 6.w),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF333333),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
