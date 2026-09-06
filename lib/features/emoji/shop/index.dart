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

import 'package:beaver/api/emoji.dart';
import 'package:beaver/types/api/emoji.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('emoji-shop');

class EmojiShopScreen extends StatefulWidget {
  const EmojiShopScreen({super.key});

  @override
  State<EmojiShopScreen> createState() => _EmojiShopScreenState();
}

class _EmojiShopScreenState extends State<EmojiShopScreen> {
  List<EmojiShopPackageItem> _packages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    _logger.info({'text': '加载表情商店列表'});
    final res = await getEmojiPackagesApi({'page': 1, 'size': 50});
    if (res.code == 0 && res.result != null) {
      setState(() {
        _packages = res.result!.list;
        _isLoading = false;
      });
      _logger.info({
        'text': '表情商店列表加载完成',
        'data': {'count': res.result!.list.length},
      });
    } else {
      setState(() => _isLoading = false);
      _logger.warn({
        'text': '表情商店列表加载失败',
        'data': {'code': res.code, 'msg': res.msg},
      });
    }
  }

  Future<void> _handleSubscribe(EmojiShopPackageItem item) async {
    final action = item.isCollected ? 'unfavorite' : 'favorite';
    _logger.info({
      'text': '订阅/取消表情包',
      'data': {'packageId': item.packageId, 'type': action},
    });
    final res = await updateFavoriteEmojiPackageApi({
      'packageId': item.packageId,
      'type': action,
    });
    if (res.code == 0) {
      _logger.info({
        'text': '表情包订阅状态已更新',
        'data': {'packageId': item.packageId, 'type': action},
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(item.isCollected ? '已取消订阅' : '订阅成功')),
      );
      _loadPackages(); // 刷新状态
    } else {
      _logger.warn({
        'text': '表情包订阅操作失败',
        'data': {'packageId': item.packageId, 'type': action, 'code': res.code, 'msg': res.msg},
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          '表情商店',
          style: TextStyle(
            color: const Color(0xFF1D2129),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.w, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _packages.isEmpty
          ? _buildEmpty()
          : _buildList(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_outlined, size: 80.w, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            '没有找到表情包',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.w,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.75,
      ),
      itemCount: _packages.length,
      itemBuilder: (context, index) {
        final item = _packages[index];
        return _buildPackageItem(item);
      },
    );
  }

  Widget _buildPackageItem(EmojiShopPackageItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: BeaverCachedImage(
                    fileUrl: item.coverFile,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      color: Colors.grey[100],
                      child: Icon(Icons.image, color: Colors.grey[300]),
                    ),
                  ),
                ),
                if (item.type == 'official')
                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7D45),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '官方',
                        style: TextStyle(color: Colors.white, fontSize: 10.sp),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D2129),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${item.emojiCount}个表情',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.infinity,
                  height: 30.h,
                  child: ElevatedButton(
                    onPressed: () => _handleSubscribe(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.isCollected
                          ? const Color(0xFFF2F3F5)
                          : const Color(0xFFFF7D45),
                      foregroundColor: item.isCollected
                          ? const Color(0xFF4E5969)
                          : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      item.isCollected ? '已添加' : '添加',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
