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
import 'package:beaver/features/discover/main/bloc/bloc.dart';
import 'package:beaver/features/discover/main/bloc/event.dart';
import 'package:beaver/features/discover/main/bloc/state.dart';
import 'package:beaver/features/discover/main/data/models/discover.dart';
import 'package:beaver/features/discover/main/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/notification/notification.dart';

class DiscoverMainPage extends StatefulWidget {
  const DiscoverMainPage({super.key});

  @override
  State<DiscoverMainPage> createState() => _DiscoverMainPageState();
}

class _DiscoverMainPageState extends State<DiscoverMainPage> {
  late DiscoverBloc _discoverBloc;

  @override
  void initState() {
    super.initState();
    _discoverBloc = DiscoverBloc(DiscoverMainRepository())
      ..add(const LoadDiscoverItemsEvent());
  }

  @override
  void dispose() {
    _discoverBloc.close();
    super.dispose();
  }

  void _onItemTap(DiscoverItem item) {
    if (item.route.isEmpty) return;
    context.push(item.route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _discoverBloc,
      child: BlocConsumer<DiscoverBloc, DiscoverState>(
        listener: (context, state) {
          if (state.status == DiscoverStatus.error &&
              state.errorMessage != null) {
            BeaverToast.show(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '发现',
            showBack: false,
            isScrollable: false,
            child: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(DiscoverState state) {
    if (state.status == DiscoverStatus.loading && state.discoverItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocBuilder<NotificationStore, NotificationStoreState>(
      builder: (context, notificationState) {
        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
          itemCount: state.discoverItems.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.w),
          itemBuilder: (context, index) {
            final item = state.discoverItems[index];
            final badgeCount =
                item.id == 'moment' ? notificationState.momentUnread : 0;
            return _buildDiscoverTile(item, badgeCount);
          },
        );
      },
    );
  }

  Widget _buildDiscoverTile(DiscoverItem item, int badgeCount) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.w),
      child: InkWell(
        onTap: () => _onItemTap(item),
        borderRadius: BorderRadius.circular(8.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            border: Border.all(color: const Color(0xFFEBEEF5)),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E8),
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    item.iconPath,
                    width: 22.w,
                    height: 22.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFF7D45),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
              ),
              if (badgeCount > 0)
                Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7D45),
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: TextStyle(fontSize: 11.sp, color: Colors.white),
                  ),
                ),
              SvgPicture.asset(
                'assets/icons/common/arrow-right.svg',
                width: 16.w,
                height: 16.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFB2BEC3),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
