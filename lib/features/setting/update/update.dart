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
import 'package:beaver/features/setting/update/bloc/bloc.dart';
import 'package:beaver/features/setting/update/bloc/event.dart';
import 'package:beaver/features/setting/update/bloc/state.dart';
import 'package:beaver/features/setting/update/data/repositories/repository.dart';
import 'package:beaver/features/setting/update/data/models/update.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> with TickerProviderStateMixin {
  late UpdateBloc _updateBloc;
  late AnimationController _refreshIconController;

  @override
  void initState() {
    super.initState();
    _updateBloc = UpdateBloc(UpdateRepository());
    _refreshIconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _updateBloc.close();
    _refreshIconController.dispose();
    super.dispose();
  }

  void _checkUpdate() {
    _updateBloc.add(OpenUpdateModalEvent());
  }

  String _formatLastCheckTime(DateTime? lastCheckTime) {
    if (lastCheckTime == null) return '';
    final diffInMinutes = DateTime.now().difference(lastCheckTime).inMinutes;
    if (diffInMinutes < 1) return '刚刚';
    if (diffInMinutes < 60) return '${diffInMinutes}分钟前';
    if (diffInMinutes < 1440) return '${(diffInMinutes / 60).floor()}小时前';
    return '${(diffInMinutes / 1440).floor()}天前';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _updateBloc,
      child: BlocConsumer<UpdateBloc, UpdateState>(
        listener: (context, state) {
          if (state.status == UpdateStatus.loading) {
            _refreshIconController.repeat();
          } else {
            _refreshIconController.stop();
          }
        },
        builder: (context, state) {
          final updateInfo = state.updateInfo;
          final isChecking = state.status == UpdateStatus.loading;

          return BeaverLayout(
            title: '检查更新',
            showBack: true,
            showWsStatus: false,
            isScrollable: false,
            overlay: state.showUpdateModal ? _buildResultDialog(state) : null,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32.w),
                    margin: EdgeInsets.only(bottom: 24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: Offset(0, 4.w),
                          blurRadius: 20.w,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.w),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 80.w,
                            height: 80.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16.w),
                        Text(
                          'Beaver',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          '当前版本 ${state.currentVersion}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF636E72),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: isChecking ? null : _checkUpdate,
                    child: Container(
                      width: double.infinity,
                      height: 48.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
                        ),
                        borderRadius: BorderRadius.circular(24.w),
                      ),
                      alignment: Alignment.center,
                      child: isChecking
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RotationTransition(
                                  turns: _refreshIconController,
                                  child: SvgPicture.asset(
                                    'assets/images/update/refresh.svg',
                                    width: 18.w,
                                    height: 18.w,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '检查中...',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              '检查更新',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                  if (updateInfo?.lastCheckTime != null)
                    Padding(
                      padding: EdgeInsets.only(top: 16.w),
                      child: Text(
                        '上次检查：${_formatLastCheckTime(updateInfo!.lastCheckTime)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFFB2BEC3),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultDialog(UpdateState state) {
    final updateInfo = state.updateInfo;

    if (state.status == UpdateStatus.error) {
      return BeaverDialog(
        title: '检查失败',
        contentText: state.errorMessage ?? '检查更新失败',
        showCancel: false,
        confirmText: '知道了',
        onCancel: () {},
        onConfirm: () => _updateBloc.add(CloseUpdateModalEvent()),
      );
    }

    if (updateInfo?.hasUpdate == true && updateInfo?.latestVersion != null) {
      final version = updateInfo!.latestVersion!;
      final notes = version.releaseNotes.trim();
      return BeaverDialog(
        title: '发现新版本',
        showCancel: !version.isForce,
        cancelText: '稍后再说',
        confirmText: updateInfo.isDownloading ? '下载中...' : '立即更新',
        maskClosable: !version.isForce && !updateInfo.isDownloading,
        onCancel: () => _updateBloc.add(CloseUpdateModalEvent()),
        onConfirm: updateInfo.isDownloading
            ? () {}
            : () => _updateBloc.add(DownloadUpdateEvent()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'v${version.version} · ${version.size}',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFFF7D45),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (notes.isNotEmpty) ...[
              SizedBox(height: 12.w),
              Text(
                notes,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF636E72),
                  height: 1.5,
                ),
              ),
            ],
            if (updateInfo.isDownloading) ...[
              SizedBox(height: 16.w),
              ClipRRect(
                borderRadius: BorderRadius.circular(3.w),
                child: LinearProgressIndicator(
                  value: updateInfo.downloadProgress / 100,
                  minHeight: 6.w,
                  backgroundColor: const Color(0xFFF0F2F5),
                  color: const Color(0xFFFF7D45),
                ),
              ),
              SizedBox(height: 8.w),
              Text(
                '下载中 ${updateInfo.downloadProgress}%',
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72)),
              ),
            ],
          ],
        ),
      );
    }

    return BeaverDialog(
      title: '已是最新版本',
      contentText: '您当前使用的是最新版本，无需更新',
      showCancel: false,
      confirmText: '知道了',
      onCancel: () {},
      onConfirm: () => _updateBloc.add(CloseUpdateModalEvent()),
    );
  }
}
